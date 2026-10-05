class AppCumulativeChartData {
  final List<double> actualValues;
  final List<double> projectedValues;
  final List<double> previousValues;
  final int currentDay;
  final int periodLength;
  final int previousPeriodLength;
  final double currentValue;
  final double target;

  const AppCumulativeChartData({
    required this.actualValues,
    required this.currentDay,
    required this.periodLength,
    required this.currentValue,
    this.projectedValues = const [],
    this.previousValues = const [],
    this.previousPeriodLength = 30,
    this.target = 0,
  });

  double get projectedEnd => projectedValues.isEmpty ? currentValue : projectedValues.last;
}
