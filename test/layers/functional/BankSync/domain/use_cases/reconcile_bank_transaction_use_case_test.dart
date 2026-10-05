import 'package:depenses/layers/functional/BankSync/domain/entities/bank_import_batch.dart';
import 'package:depenses/layers/functional/BankSync/domain/entities/bank_link.dart';
import 'package:depenses/layers/functional/BankSync/domain/entities/bank_transaction.dart';
import 'package:depenses/layers/functional/BankSync/domain/entities/reconcile_outcome.dart';
import 'package:depenses/layers/functional/BankSync/domain/use_cases/reconcile_bank_transaction_use_case.dart';
import 'package:depenses/layers/functional/Categories/domain/entities/category.dart';
import 'package:depenses/layers/functional/Categories/domain/use_cases/guess_category_use_case.dart';
import 'package:depenses/layers/functional/Expenses/domain/entities/expense.dart';
import 'package:depenses/layers/functional/Expenses/domain/entities/expense_origin.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/sequential_id_generator.dart';
import '../../../../../support/test_dependencies.dart';

BankTransaction _debit({
  String id = 'tx-1',
  double amount = 42.3,
  DateTime? date,
  bool isPending = false,
  String rawLabel = 'CB CARREFOUR 03/10 PARIS 12',
  BankTransactionDirection direction = BankTransactionDirection.debit,
}) => BankTransaction(
  id: id,
  date: date ?? DateTime(2026, 10, 3),
  amount: amount,
  direction: direction,
  isPending: isPending,
  rawLabel: rawLabel,
);

Expense _manual(String id, {double amount = 42.3, DateTime? date, String? bankTransactionId}) => Expense(
  id: id,
  name: 'Courses',
  amount: amount,
  date: date ?? DateTime(2026, 10, 3),
  categoryKey: 'ali',
  roundUp: 0.7,
  bankTransactionId: bankTransactionId,
);

BankLink _link({String expenseId = 'e1', BankLinkKind kind = BankLinkKind.created, bool wasPending = false}) =>
    BankLink(transactionId: 'tx-1', expenseId: expenseId, accountUid: 'acc-1', kind: kind, wasPending: wasPending);

void main() {
  late TestDependencies dependencies;
  late ReconcileBankTransactionUseCase reconcile;

  setUp(() {
    dependencies = TestDependencies();
    reconcile = ReconcileBankTransactionUseCase(dependencies.get<GuessCategoryUseCase>(), SequentialIdGenerator('b'));
  });
  tearDown(() => dependencies.dispose());

  BankImportBatch batchOf({
    List<Expense> expenses = const [],
    List<BankLink> links = const [],
    List<String> dismissed = const [],
  }) => BankImportBatch(expenses: expenses, links: links, dismissed: dismissed);

  ReconcileOutcome run(BankTransaction transaction, BankImportBatch batch) =>
      reconcile(transaction, accountUid: 'acc-1', batch: batch);

  test('skips credits', () {
    final batch = batchOf();

    expect(run(_debit(direction: BankTransactionDirection.credit), batch), ReconcileOutcome.skipped);
    expect(batch.hasChanges, isFalse);
  });

  test('creates an imported expense without round-up, named and categorised from the label', () {
    final batch = batchOf();

    expect(run(_debit(isPending: true), batch), ReconcileOutcome.created);

    final created = batch.createdExpenses.single;
    expect(created.id, 'b1');
    expect(created.name, 'Carrefour');
    expect(created.amount, 42.3);
    expect(created.date, DateTime(2026, 10, 3));
    expect(created.categoryKey, 'ali');
    expect(created.roundUp, 0);
    expect(created.origin, ExpenseOrigin.bank);
    expect(created.bankTransactionId, 'tx-1');
    expect(batch.links.single, _link(expenseId: 'b1', wasPending: true));
  });

  test('falls back on the other category when nothing is recognised', () {
    final batch = batchOf();

    run(_debit(rawLabel: 'PRLV SEPA XYZW'), batch);

    expect(batch.createdExpenses.single.categoryKey, Category.otherKey);
  });

  test('skips a transaction the user dismissed', () {
    final batch = batchOf(dismissed: ['tx-1']);

    expect(run(_debit(), batch), ReconcileOutcome.skipped);
    expect(batch.hasChanges, isFalse);
  });

  test('links the closest manual expense of the same amount within three days', () {
    final batch = batchOf(
      expenses: [
        _manual('far', date: DateTime(2026, 10, 6)),
        _manual('close', date: DateTime(2026, 10, 2)),
      ],
    );

    expect(run(_debit(), batch), ReconcileOutcome.matched);

    final matched = batch.changedExpenses.single;
    expect(matched.id, 'close');
    expect(matched.name, 'Courses');
    expect(matched.roundUp, 0.7);
    expect(matched.bankTransactionId, 'tx-1');
    expect(batch.links.single, _link(expenseId: 'close', kind: BankLinkKind.matched));
  });

  test('creates instead of matching when the amount, the date or the expense does not fit', () {
    final batch = batchOf(
      expenses: [
        _manual('later', date: DateTime(2026, 10, 7)),
        _manual('dearer', amount: 42.31),
        _manual('linked', bankTransactionId: 'tx-0'),
        _manual('imported').copyWith(origin: ExpenseOrigin.bank),
      ],
    );

    expect(run(_debit(), batch), ReconcileOutcome.created);
  });

  test('never touches a booked transaction already linked, even after a user edit', () {
    final edited = _manual('e1', amount: 40).copyWith(name: 'Courses du mois', origin: ExpenseOrigin.bank);
    final batch = batchOf(expenses: [edited], links: [_link()]);

    expect(run(_debit(), batch), ReconcileOutcome.unchanged);
    expect(batch.hasChanges, isFalse);
  });

  test('updates an imported pending expense once the bank books it with another amount and label', () {
    final pending = _manual('e1', amount: 40).copyWith(name: 'Carrefour City', origin: ExpenseOrigin.bank);
    final batch = batchOf(expenses: [pending], links: [_link(wasPending: true)]);

    expect(run(_debit(date: DateTime(2026, 10, 4)), batch), ReconcileOutcome.updated);

    final updated = batch.changedExpenses.single;
    expect(updated.amount, 42.3);
    expect(updated.date, DateTime(2026, 10, 4));
    expect(updated.name, 'Carrefour');
    expect(updated.categoryKey, 'ali');
    expect(batch.links.single.wasPending, isFalse);
  });

  test('keeps the user name of a matched expense when its pending transaction is booked', () {
    final batch = batchOf(
      expenses: [_manual('e1', amount: 40)],
      links: [_link(kind: BankLinkKind.matched, wasPending: true)],
    );

    expect(run(_debit(), batch), ReconcileOutcome.updated);
    expect(batch.changedExpenses.single.name, 'Courses');
    expect(batch.changedExpenses.single.amount, 42.3);
  });

  test('only clears the pending flag when the booked transaction did not change', () {
    final pending = _manual('e1').copyWith(name: 'Carrefour', origin: ExpenseOrigin.bank);
    final batch = batchOf(expenses: [pending], links: [_link(wasPending: true)]);

    expect(run(_debit(), batch), ReconcileOutcome.unchanged);
    expect(batch.changedExpenses, isEmpty);
    expect(batch.links.single.wasPending, isFalse);
    expect(batch.hasChanges, isTrue);
  });

  test('does not recreate a linked transaction whose expense is gone', () {
    final batch = batchOf(links: [_link(kind: BankLinkKind.matched, wasPending: true)]);

    expect(run(_debit(isPending: true), batch), ReconcileOutcome.unchanged);
    expect(batch.hasChanges, isFalse);
  });
}
