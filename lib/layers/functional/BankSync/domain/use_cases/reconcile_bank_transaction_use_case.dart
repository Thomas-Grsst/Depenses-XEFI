import 'package:depenses/layers/functional/Categories/domain/entities/category.dart';
import 'package:depenses/layers/functional/Categories/domain/use_cases/guess_category_use_case.dart';
import 'package:depenses/layers/functional/Expenses/domain/entities/expense.dart';
import 'package:depenses/layers/functional/Expenses/domain/entities/expense_origin.dart';
import 'package:depenses/layers/technical/Storage/id_generator.dart';

import '../entities/bank_import_batch.dart';
import '../entities/bank_label_cleaner.dart';
import '../entities/bank_link.dart';
import '../entities/bank_transaction.dart';
import '../entities/reconcile_outcome.dart';

class ReconcileBankTransactionUseCase {
  ReconcileBankTransactionUseCase(this._guessCategory, this._ids, {this._cleaner = const BankLabelCleaner()});

  final GuessCategoryUseCase _guessCategory;
  final IdGenerator _ids;
  final BankLabelCleaner _cleaner;

  ReconcileOutcome call(BankTransaction transaction, {required String accountUid, required BankImportBatch batch}) {
    if (!transaction.isDebit) return ReconcileOutcome.skipped;
    final link = batch.linkOf(transaction.id);
    if (link != null) return _refreshLinked(transaction, link, batch);
    if (batch.isDismissed(transaction.id)) return ReconcileOutcome.skipped;
    final manualExpense = batch.manualMatchFor(transaction);
    if (manualExpense != null) return _match(transaction, manualExpense, accountUid, batch);
    return _create(transaction, accountUid, batch);
  }

  ReconcileOutcome _refreshLinked(BankTransaction transaction, BankLink link, BankImportBatch batch) {
    if (!link.wasPending) return ReconcileOutcome.unchanged;
    final refreshedLink = link.copyWith(wasPending: transaction.isPending);
    final expense = batch.expenseOf(link.expenseId);
    final refreshed = expense == null ? null : _refreshed(expense, transaction, link.kind);
    if (refreshed == null || refreshed == expense) {
      batch.relink(refreshedLink);
      return ReconcileOutcome.unchanged;
    }
    batch.record(refreshed, refreshedLink);
    return ReconcileOutcome.updated;
  }

  Expense _refreshed(Expense expense, BankTransaction transaction, BankLinkKind kind) => expense.copyWith(
    amount: transaction.amount,
    date: transaction.date,
    name: kind == BankLinkKind.created ? _cleaner.clean(transaction.rawLabel) : null,
  );

  ReconcileOutcome _match(BankTransaction transaction, Expense expense, String accountUid, BankImportBatch batch) {
    batch.record(
      expense.copyWith(bankTransactionId: () => transaction.id),
      _linkFor(transaction, expense.id, accountUid, BankLinkKind.matched),
    );
    return ReconcileOutcome.matched;
  }

  ReconcileOutcome _create(BankTransaction transaction, String accountUid, BankImportBatch batch) {
    final name = _cleaner.clean(transaction.rawLabel);
    final expense = Expense(
      id: _ids.next(),
      name: name,
      amount: transaction.amount,
      date: transaction.date,
      categoryKey: _guessCategory(name) ?? _guessCategory(transaction.rawLabel) ?? Category.otherKey,
      origin: ExpenseOrigin.bank,
      bankTransactionId: transaction.id,
    );
    batch.record(expense, _linkFor(transaction, expense.id, accountUid, BankLinkKind.created));
    return ReconcileOutcome.created;
  }

  BankLink _linkFor(BankTransaction transaction, String expenseId, String accountUid, BankLinkKind kind) => BankLink(
    transactionId: transaction.id,
    expenseId: expenseId,
    accountUid: accountUid,
    kind: kind,
    wasPending: transaction.isPending,
  );
}
