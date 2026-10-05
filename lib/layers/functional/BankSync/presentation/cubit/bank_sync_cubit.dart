import 'dart:async';

import 'package:depenses/layers/technical/OpenBanking/enable_banking_errors.dart';
import 'package:depenses/layers/technical/Storage/ledger_changes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/linked_bank_account.dart';
import '../../domain/entities/sync_report.dart';
import '../../domain/use_cases/get_linked_accounts_use_case.dart';
import '../../domain/use_cases/is_bank_sync_available_use_case.dart';
import '../../domain/use_cases/synchronize_bank_accounts_use_case.dart';
import '../../domain/use_cases/unlink_bank_account_use_case.dart';
import 'bank_sync_failure.dart';
import 'bank_sync_state.dart';

class BankSyncCubit extends Cubit<BankSyncState> {
  BankSyncCubit(this._isAvailable, this._getAccounts, this._unlink, this._synchronize, LedgerChanges changes)
    : super(const BankSyncState()) {
    _subscription = changes.changes.listen((_) => load());
    load();
  }

  final IsBankSyncAvailableUseCase _isAvailable;
  final GetLinkedAccountsUseCase _getAccounts;
  final UnlinkBankAccountUseCase _unlink;
  final SynchronizeBankAccountsUseCase _synchronize;
  late final StreamSubscription<void> _subscription;

  void load() {
    if (isClosed) return;
    emit(state.copyWith(isAvailable: _isAvailable(), accounts: _getAccounts()));
  }

  Future<void> synchronize() async {
    if (state.isBusy) return;
    emit(state.copyWith(status: BankSyncStatus.synchronizing, clearsReport: true, failure: BankSyncFailure.none));
    try {
      final report = await _synchronize();
      _settle(report: report);
    } on BankApiException catch (error) {
      _settle(failure: BankSyncFailure.of(error));
    }
  }

  Future<void> unlink(LinkedBankAccount account) async {
    if (state.isBusy) return;
    emit(state.copyWith(status: BankSyncStatus.unlinking, failure: BankSyncFailure.none));
    try {
      await _unlink(account);
      _settle();
    } on BankApiException catch (error) {
      _settle(failure: BankSyncFailure.of(error));
    }
  }

  void _settle({SyncReport? report, BankSyncFailure failure = BankSyncFailure.none}) {
    if (isClosed) return;
    emit(state.copyWith(status: BankSyncStatus.ready, report: report, failure: failure, accounts: _getAccounts()));
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
