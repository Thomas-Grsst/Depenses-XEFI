import 'package:depenses/layers/technical/Theme/app_cumulative_chart_data.dart';

import '../../domain/entities/month_stats.dart';

extension ForecastChartData on MonthStats {
  AppCumulativeChartData get chartData => AppCumulativeChartData(
    actualValues: realCurve,
    projectedValues: forecastCurve,
    previousValues: previousFull > 0 ? previousCurve : const [],
    currentDay: day,
    periodLength: daysInMonth,
    previousPeriodLength: previousDaysInMonth,
    currentValue: spent,
    target: budget,
  );
}
