import 'package:equatable/equatable.dart';

import 'budget_alert.dart';
import 'category_move.dart';
import 'month_stats.dart';

class ForecastSummary extends Equatable {
  const ForecastSummary({
    required this.stats,
    required this.alerts,
    required this.largestMoves,
    required this.areAlertsEnabled,
  });

  final MonthStats stats;
  final List<BudgetAlert> alerts;
  final List<CategoryMove> largestMoves;
  final bool areAlertsEnabled;

  @override
  List<Object?> get props => [stats, alerts, largestMoves, areAlertsEnabled];
}
