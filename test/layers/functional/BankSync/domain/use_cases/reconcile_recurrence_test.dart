import 'package:depenses/layers/functional/BankSync/domain/entities/bank_import_batch.dart';
import 'package:depenses/layers/functional/BankSync/domain/entities/bank_link.dart';
import 'package:depenses/layers/functional/BankSync/domain/entities/bank_transaction.dart';
import 'package:depenses/layers/functional/BankSync/domain/entities/reconcile_outcome.dart';
import 'package:depenses/layers/functional/BankSync/domain/use_cases/reconcile_bank_transaction_use_case.dart';
import 'package:depenses/layers/functional/Categories/domain/use_cases/guess_category_use_case.dart';
import 'package:depenses/layers/functional/Expenses/domain/entities/expense.dart';
import 'package:depenses/layers/functional/Expenses/domain/entities/expense_origin.dart';
import 'package:depenses/layers/functional/Recurrences/domain/entities/frequency.dart';
import 'package:depenses/layers/functional/Recurrences/domain/entities/recurrence.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/sequential_id_generator.dart';
import '../../../../../support/test_dependencies.dart';

BankTransaction _debit({double amount = 812, DateTime? date, String rawLabel = 'VIR SEPA LOYER OCTOBRE'}) =>
    BankTransaction(
      id: 'tx-1',
      date: date ?? DateTime(2026, 10, 7),
      amount: amount,
      direction: BankTransactionDirection.debit,
      isPending: false,
      rawLabel: rawLabel,
    );

Recurrence _recurrence(String id, {String name = 'Loyer', double amount = 800, int day = 5, DateTime? lastGenerated}) =>
    Recurrence(
      id: id,
      name: name,
      amount: amount,
      categoryKey: 'log',
      frequency: Frequency.month,
      start: DateTime(2026, 8, day),
      labels: const ['maison'],
      lastGeneratedOn: lastGenerated ?? DateTime(2026, 10, 15),
    );

Expense _generated(String id, Recurrence recurrence, DateTime date, {String? bankTransactionId}) => Expense(
  id: id,
  name: recurrence.name,
  amount: recurrence.amount,
  date: date,
  categoryKey: recurrence.categoryKey,
  labels: recurrence.labels,
  recurrenceId: recurrence.id,
  bankTransactionId: bankTransactionId,
);

void main() {
  late TestDependencies dependencies;
  late ReconcileBankTransactionUseCase reconcile;
  final rent = _recurrence('r-rent');
  final september = _generated('g-sep', rent, DateTime(2026, 9, 5));
  final october = _generated('g-oct', rent, DateTime(2026, 10, 5));

  setUp(() {
    dependencies = TestDependencies();
    reconcile = ReconcileBankTransactionUseCase(dependencies.get<GuessCategoryUseCase>(), SequentialIdGenerator('b'));
  });
  tearDown(() => dependencies.dispose());

  BankImportBatch batchOf({List<Expense>? expenses, List<Recurrence>? recurrences, List<BankLink> links = const []}) =>
      BankImportBatch(
        expenses: expenses ?? [september, october],
        links: links,
        dismissed: const [],
        recurrences: recurrences ?? [rent],
      );

  ReconcileOutcome run(BankTransaction transaction, BankImportBatch batch) =>
      reconcile(transaction, accountUid: 'acc-1', batch: batch);

  test('replaces the generated expense of the matching occurrence by the real operation', () {
    final batch = batchOf();

    expect(run(_debit(), batch), ReconcileOutcome.attachedToRecurrence);

    expect(batch.createdExpenses, isEmpty);
    expect(
      batch.changedExpenses.single,
      october.copyWith(
        amount: 812,
        date: DateTime(2026, 10, 7),
        origin: ExpenseOrigin.bank,
        bankTransactionId: () => 'tx-1',
      ),
    );
    expect(
      batch.links.single,
      const BankLink(
        transactionId: 'tx-1',
        expenseId: 'g-oct',
        accountUid: 'acc-1',
        kind: BankLinkKind.recurrence,
        wasPending: false,
      ),
    );
  });

  test('recognises a close name by a shared first word or an inclusion', () {
    final namesAndLabels = {
      'Free Mobile': 'PRLV SEPA FREE TELECOM',
      'Loyer': 'VIR AGENCE DUPONT LOYER',
      'Loyer appartement': 'VIR SEPA LOYER',
      'Électricité': 'PRLV SEPA EDF 123456789 ELECTRICITE',
    };

    namesAndLabels.forEach((name, label) {
      final recurrence = _recurrence('r-$name', name: name);
      final batch = batchOf(
        recurrences: [recurrence],
        expenses: [_generated('g-$name', recurrence, DateTime(2026, 10, 5))],
      );
      expect(run(_debit(rawLabel: label), batch), ReconcileOutcome.attachedToRecurrence, reason: label);
    });
  });

  test('creates a plain expense when the amount, the date or the name does not fit', () {
    final misfits = [
      _debit(amount: 840),
      _debit(amount: 800, date: DateTime(2026, 10, 12)),
      _debit(rawLabel: 'CB CARREFOUR 07/10'),
    ];

    for (final transaction in misfits) {
      final batch = batchOf();
      expect(run(transaction, batch), ReconcileOutcome.created);
      expect(batch.createdExpenses.single.recurrenceId, isNull);
      expect(batch.changedExpenses, isEmpty);
    }
  });

  test('attaches the operation to the closest recurrence', () {
    final car = _recurrence('r-car', name: 'Assurance auto', amount: 45, day: 10);
    final home = _recurrence('r-home', name: 'Assurance habitation', amount: 46, day: 12);
    final batch = batchOf(
      recurrences: [home, car],
      expenses: [_generated('g-home', home, DateTime(2026, 10, 12)), _generated('g-car', car, DateTime(2026, 10, 10))],
    );

    run(_debit(amount: 45, date: DateTime(2026, 10, 10), rawLabel: 'PRLV SEPA ASSURANCE'), batch);

    expect(batch.changedExpenses.single.id, 'g-car');
  });

  test('creates an imported expense of the recurrence when no generated expense is free', () {
    final batch = batchOf(expenses: [_generated('g-oct', rent, DateTime(2026, 10, 5), bankTransactionId: 'tx-0')]);

    expect(run(_debit(), batch), ReconcileOutcome.attachedToRecurrence);

    final created = batch.createdExpenses.single;
    expect(created.id, 'b1');
    expect(created.name, 'Loyer');
    expect(created.categoryKey, 'log');
    expect(created.labels, ['maison']);
    expect(created.recurrenceId, 'r-rent');
    expect(created.origin, ExpenseOrigin.bank);
    expect(created.roundUp, 0);
    expect(batch.links.single.kind, BankLinkKind.recurrence);
    expect(batch.changedRecurrences, isEmpty);
  });

  test('marks a future occurrence as generated when its operation arrives early', () {
    final early = _recurrence('r-rent', day: 17);
    final batch = batchOf(recurrences: [early], expenses: const []);

    run(_debit(amount: 800, date: DateTime(2026, 10, 14)), batch);

    expect(batch.createdExpenses.single.recurrenceId, 'r-rent');
    expect(batch.changedRecurrences.single, early.copyWith(lastGeneratedOn: DateTime(2026, 10, 17)));
  });

  test('keeps an earlier occurrence still to generate when the operation arrives early', () {
    final late = _recurrence('r-rent', day: 17, lastGenerated: DateTime(2026, 9, 10));
    final batch = batchOf(recurrences: [late], expenses: const []);

    run(_debit(amount: 800, date: DateTime(2026, 10, 14)), batch);

    expect(batch.createdExpenses.single.recurrenceId, 'r-rent');
    expect(batch.changedRecurrences, isEmpty);
  });

  test('keeps the recurrence name when a pending operation attached to it is booked', () {
    final attached = october.copyWith(amount: 790, origin: ExpenseOrigin.bank, bankTransactionId: () => 'tx-1');
    final link = BankLink(
      transactionId: 'tx-1',
      expenseId: attached.id,
      accountUid: 'acc-1',
      kind: BankLinkKind.recurrence,
      wasPending: true,
    );
    final batch = batchOf(expenses: [attached], links: [link]);

    expect(run(_debit(), batch), ReconcileOutcome.updated);
    expect(batch.changedExpenses.single.name, 'Loyer');
    expect(batch.changedExpenses.single.amount, 812);
  });
}
