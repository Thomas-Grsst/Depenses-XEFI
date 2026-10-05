import 'package:depenses/layers/functional/Expenses/domain/gateways/expense_gateway.dart';
import 'package:depenses/layers/technical/Calendar/clock.dart';
import 'package:depenses/layers/technical/OpenBanking/enable_banking_errors.dart';

import '../entities/bank_import_batch.dart';
import '../entities/linked_bank_account.dart';
import '../entities/reconcile_outcome.dart';
import '../entities/sync_report.dart';
import '../gateways/bank_data_gateway.dart';
import '../gateways/bank_link_gateway.dart';
import '../gateways/linked_account_gateway.dart';
import 'reconcile_bank_transaction_use_case.dart';

const _firstSyncHistoryDays = 90;
const _pendingCatchUpDays = 10;

class SynchronizeBankAccountsUseCase {
  SynchronizeBankAccountsUseCase(
    this._accounts,
    this._bankData,
    this._links,
    this._expenses,
    this._reconcile,
    this._clock, {
    this._now = DateTime.now,
  });

  final LinkedAccountGateway _accounts;
  final BankDataGateway _bankData;
  final BankLinkGateway _links;
  final ExpenseGateway _expenses;
  final ReconcileBankTransactionUseCase _reconcile;
  final Clock _clock;
  final DateTime Function() _now;
  Future<SyncReport>? _running;

  Future<SyncReport> call() => _running ??= _synchronizeAll().whenComplete(() => _running = null);

  Future<SyncReport> _synchronizeAll() async {
    var report = const SyncReport();
    final active = _accounts.all().where((account) => account.statusAt(_now()) == LinkedAccountStatus.linked);
    for (final account in active.toList()) {
      try {
        report += await _synchronize(account);
      } on BankAccessExpiredException {
        await _accounts.save(account.copyWith(isRevoked: true));
      }
    }
    return report;
  }

  Future<SyncReport> _synchronize(LinkedBankAccount account) async {
    final from = _windowStart(account);
    final transactions = await _bankData.transactions(account, from);
    final balance = await _bankData.balance(account);
    final batch = BankImportBatch(expenses: _expenses.all(), links: _links.all(), dismissed: _links.dismissed());
    final outcomes = [
      for (final transaction in transactions) _reconcile(transaction, accountUid: account.uid, batch: batch),
    ];
    final removed = batch.dropVanishedPending(
      accountUid: account.uid,
      seenTransactionIds: {for (final transaction in transactions) transaction.id},
      from: from,
    );
    await _persist(batch);
    await _accounts.save(account.copyWith(lastSyncedAt: _now(), lastBankBalance: balance));
    return SyncReport(
      created: _count(outcomes, ReconcileOutcome.created),
      updated: _count(outcomes, ReconcileOutcome.updated),
      matched: _count(outcomes, ReconcileOutcome.matched),
      attachedToRecurrence: _count(outcomes, ReconcileOutcome.attachedToRecurrence),
      removed: removed,
      skipped: _count(outcomes, ReconcileOutcome.skipped),
      bankBalance: balance,
    );
  }

  DateTime _windowStart(LinkedBankAccount account) {
    final lastSyncedAt = account.lastSyncedAt;
    if (lastSyncedAt == null) return _daysBefore(_clock.today(), _firstSyncHistoryDays);
    return _daysBefore(lastSyncedAt, _pendingCatchUpDays);
  }

  static DateTime _daysBefore(DateTime date, int days) => DateTime(date.year, date.month, date.day - days);

  Future<void> _persist(BankImportBatch batch) async {
    if (!batch.hasChanges) return;
    if (batch.createdExpenses.isNotEmpty) await _expenses.addAll(batch.createdExpenses);
    for (final expense in batch.changedExpenses) {
      await _expenses.update(expense);
    }
    for (final id in batch.removedExpenseIds) {
      await _expenses.delete(id);
    }
    await _links.saveAll(batch.links);
  }

  static int _count(List<ReconcileOutcome> outcomes, ReconcileOutcome outcome) =>
      outcomes.where((candidate) => candidate == outcome).length;
}
