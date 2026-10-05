import '../entities/forecast_summary.dart';
import 'compute_month_stats_use_case.dart';
import 'detect_budget_alerts_use_case.dart';
import 'get_alerts_enabled_use_case.dart';
import 'get_category_moves_use_case.dart';

class GetForecastSummaryUseCase {
  GetForecastSummaryUseCase(this._stats, this._alerts, this._moves, this._alertsEnabled);

  final ComputeMonthStatsUseCase _stats;
  final DetectBudgetAlertsUseCase _alerts;
  final GetCategoryMovesUseCase _moves;
  final GetAlertsEnabledUseCase _alertsEnabled;

  ForecastSummary call() {
    final stats = _stats();
    final moves = _moves(stats)..sort((a, b) => b.delta.abs().compareTo(a.delta.abs()));
    return ForecastSummary(
      stats: stats,
      alerts: _alerts(stats),
      largestMoves: moves,
      areAlertsEnabled: _alertsEnabled(),
    );
  }
}
