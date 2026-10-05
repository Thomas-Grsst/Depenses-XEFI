import 'package:depenses/layers/functional/Forecast/domain/entities/budget_alert.dart';
import 'package:depenses/layers/functional/Forecast/domain/use_cases/get_forecast_summary_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';
import '../../forecast_seed.dart';

void main() {
  late TestDependencies dependencies;

  tearDown(() => dependencies.dispose());

  test('bundles the stats, the alerts and the moves sorted by size', () {
    dependencies = TestDependencies(
      today: DateTime(2026, 10, 15),
      data: {
        'expenses': [
          forecastExpense('a', 120, '2026-10-03'),
          forecastExpense('b', 10, '2026-10-04', category: 'loi'),
          forecastExpense('c', 60, '2026-09-03'),
          forecastExpense('d', 80, '2026-09-04', category: 'loi'),
        ],
        'envelopes': {'ali': 100},
      },
    );

    final summary = dependencies.get<GetForecastSummaryUseCase>()();

    expect(summary.stats.spent, 130);
    expect(summary.areAlertsEnabled, isTrue);
    expect(summary.alerts.single.kind, BudgetAlertKind.overspent);
    expect(summary.largestMoves.map((m) => m.categoryKey), ['loi', 'ali']);
  });

  test('disabled alerts are reported and produce no alert', () {
    dependencies = TestDependencies(
      today: DateTime(2026, 10, 15),
      data: {
        'expenses': [forecastExpense('a', 120, '2026-10-03')],
        'envelopes': {'ali': 100},
        'settings': {'alerts': false},
      },
    );

    final summary = dependencies.get<GetForecastSummaryUseCase>()();

    expect(summary.areAlertsEnabled, isFalse);
    expect(summary.alerts, isEmpty);
  });
}
