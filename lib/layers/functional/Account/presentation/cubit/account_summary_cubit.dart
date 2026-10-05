import 'dart:async';

import 'package:depenses/layers/functional/Forecast/domain/use_cases/compute_month_stats_use_case.dart';
import 'package:depenses/layers/technical/Storage/ledger_changes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/use_cases/get_account_summary_use_case.dart';
import 'account_summary_state.dart';

class AccountSummaryCubit extends Cubit<AccountSummaryState> {
  AccountSummaryCubit(this._computeStats, this._getSummary, LedgerChanges changes)
    : super(const AccountSummaryState()) {
    _subscription = changes.changes.listen((_) => load());
    load();
  }

  final ComputeMonthStatsUseCase _computeStats;
  final GetAccountSummaryUseCase _getSummary;
  late final StreamSubscription<void> _subscription;

  void load() {
    final stats = _computeStats();
    emit(state.copyWith(status: AccountSummaryStatus.ready, summary: _getSummary(stats), today: stats.today));
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
