import 'dart:async';

import 'package:depenses/layers/functional/Account/domain/use_cases/get_account_summary_use_case.dart';
import 'package:depenses/layers/technical/Storage/ledger_changes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/use_cases/compute_month_stats_use_case.dart';
import '../../domain/use_cases/count_remaining_recurrences_use_case.dart';
import 'forecast_state.dart';

class ForecastCubit extends Cubit<ForecastState> {
  ForecastCubit(this._computeStats, this._countRemaining, this._getAccountSummary, LedgerChanges changes)
    : super(const ForecastState()) {
    _subscription = changes.changes.listen((_) => load());
    load();
  }

  final ComputeMonthStatsUseCase _computeStats;
  final CountRemainingRecurrencesUseCase _countRemaining;
  final GetAccountSummaryUseCase _getAccountSummary;
  late final StreamSubscription<void> _subscription;

  void load() {
    final stats = _computeStats();
    emit(
      state.copyWith(
        status: ForecastStatus.ready,
        stats: stats,
        account: _getAccountSummary(stats),
        remainingRecurrences: _countRemaining(stats),
      ),
    );
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
