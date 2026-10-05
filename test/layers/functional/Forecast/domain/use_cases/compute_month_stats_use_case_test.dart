import 'package:depenses/layers/functional/Forecast/domain/entities/budget_alert.dart';
import 'package:depenses/layers/functional/Forecast/domain/use_cases/compute_month_stats_use_case.dart';
import 'package:depenses/layers/functional/Forecast/domain/use_cases/detect_budget_alerts_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';

Map<String, dynamic> _expense(String id, String cat, double amount, String date, {String? recId}) => {
  'id': id,
  'name': id,
  'amount': amount,
  'date': date,
  'cat': cat,
  'labels': <String>[],
  'recId': recId,
};

void main() {
  late TestDependencies dependencies;

  setUp(() {
    dependencies = TestDependencies(
      today: DateTime(2026, 10, 10),
      data: {
        'expenses': [
          _expense('rent', 'log', 800, '2026-10-01', recId: 'r'),
          _expense('food', 'ali', 100, '2026-10-05'),
          _expense('later', 'ali', 50, '2026-10-20'),
          _expense('unknown', 'zzz', 10, '2026-10-06'),
          _expense('previous', 'ali', 60, '2026-09-08'),
          _expense('previousLate', 'ali', 40, '2026-09-25'),
        ],
        'recs': [
          {
            'id': 'r',
            'name': 'Loyer',
            'amount': 800,
            'cat': 'log',
            'freq': 'month',
            'start': '2026-01-01',
            'labels': <String>[],
            'lastGen': '2026-10-10',
          },
          {
            'id': 'gym',
            'name': 'Salle',
            'amount': 30,
            'cat': 'san',
            'freq': 'month',
            'start': '2026-01-25',
            'labels': <String>[],
            'lastGen': '2026-10-10',
          },
        ],
        'envelopes': {'ali': 120.0, 'log': 900.0},
      },
    );
  });
  tearDown(() => dependencies.dispose());

  test('spending only counts expenses up to today and maps unknown categories to others', () {
    final stats = dependencies.get<ComputeMonthStatsUseCase>()();

    expect(stats.spent, 910);
    expect(stats.spentRecurring, 800);
    expect(stats.spentOccasional, 110);
    expect(stats.categoryOf('aut').spent, 10);
    expect(stats.realCurve, hasLength(10));
    expect(stats.realCurve.last, 910);
  });

  test('previous month is compared at the same day of month', () {
    final stats = dependencies.get<ComputeMonthStatsUseCase>()();

    expect(stats.previousSameDay, 60);
    expect(stats.previousFull, 100);
    expect(stats.versusPrevious, closeTo(910 / 60 - 1, 0.0001));
  });

  test('forecast adds the remaining recurring charges and the occasional pace', () {
    final stats = dependencies.get<ComputeMonthStatsUseCase>()();

    expect(stats.remainingRecurringTotal, 30);
    expect(stats.forecast, closeTo(910 + 30 + stats.rate * 21, 0.0001));
    expect(stats.forecastCurve.first, 910);
    expect(stats.forecastCurve.last, closeTo(stats.forecast, 0.0001));
    expect(stats.budget, 1020);
  });

  test('an envelope spent much faster than the month raises a fast pace alert', () {
    final stats = dependencies.get<ComputeMonthStatsUseCase>()();

    final alerts = dependencies.get<DetectBudgetAlertsUseCase>()(stats);

    expect(alerts.first.kind, BudgetAlertKind.fastPace);
    expect(alerts.first.categoryKey, 'ali');
  });
}
