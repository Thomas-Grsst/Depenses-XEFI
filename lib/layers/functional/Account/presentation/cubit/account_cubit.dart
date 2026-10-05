import 'dart:async';

import 'package:depenses/layers/functional/Forecast/domain/use_cases/compute_month_stats_use_case.dart';
import 'package:depenses/layers/functional/Forecast/domain/use_cases/count_remaining_recurrences_use_case.dart';
import 'package:depenses/layers/technical/Storage/ledger_changes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/use_cases/clear_balance_use_case.dart';
import '../../domain/use_cases/get_account_summary_use_case.dart';
import '../../domain/use_cases/revise_balance_use_case.dart';
import '../../domain/use_cases/save_income_use_case.dart';
import 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  AccountCubit(
    this._computeStats,
    this._countRemaining,
    this._getSummary,
    this._saveIncome,
    this._reviseBalance,
    this._clearBalance,
    LedgerChanges changes,
  ) : super(const AccountState()) {
    _subscription = changes.changes.listen((_) => load());
    load();
  }

  final ComputeMonthStatsUseCase _computeStats;
  final CountRemainingRecurrencesUseCase _countRemaining;
  final GetAccountSummaryUseCase _getSummary;
  final SaveIncomeUseCase _saveIncome;
  final ReviseBalanceUseCase _reviseBalance;
  final ClearBalanceUseCase _clearBalance;
  late final StreamSubscription<void> _subscription;

  void load() {
    final stats = _computeStats();
    final summary = _getSummary(stats);
    emit(
      state.copyWith(
        status: state.isLoaded ? state.status : AccountStatus.ready,
        stats: stats,
        summary: summary,
        remainingRecurrences: _countRemaining(stats),
        payDay: state.isLoaded ? state.payDay : summary.payDay,
      ),
    );
  }

  void selectPayDay(int payDay) => emit(state.copyWith(payDay: payDay));

  Future<void> save({required double income, required double? balance, required bool isBalanceCleared}) async {
    emit(state.copyWith(status: AccountStatus.saving));
    await _saveIncome(income: income, payDay: state.payDay);
    if (isBalanceCleared) {
      await _clearBalance();
    } else if (balance != null) {
      await _reviseBalance(balance);
    }
    emit(state.copyWith(status: AccountStatus.saved));
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
