import 'package:depenses/layers/functional/Recurrences/domain/entities/occurrence.dart';

import 'category_stats.dart';

class MonthStats {
  const MonthStats({
    required this.today,
    required this.daysInMonth,
    required this.spent,
    required this.spentRecurring,
    required this.spentOccasional,
    required this.previousSameDay,
    required this.previousFull,
    required this.hasPrevious,
    required this.budget,
    required this.rate,
    required this.estimatedOccasional,
    required this.remainingOccurrences,
    required this.remainingRecurringTotal,
    required this.forecast,
    required this.perCategory,
    required this.realCurve,
    required this.previousCurve,
    required this.forecastCurve,
    required this.previousDaysInMonth,
  });

  final DateTime today;
  final int daysInMonth;
  final double spent;
  final double spentRecurring;
  final double spentOccasional;
  final double previousSameDay;
  final double previousFull;
  final bool hasPrevious;
  final double budget;
  final double rate;
  final double estimatedOccasional;
  final List<Occurrence> remainingOccurrences;
  final double remainingRecurringTotal;
  final double forecast;
  final Map<String, CategoryStats> perCategory;
  final List<double> realCurve;
  final List<double> previousCurve;
  final List<double> forecastCurve;
  final int previousDaysInMonth;

  DateTime get month => DateTime(today.year, today.month);

  int get day => today.day;

  int get remainingDays => daysInMonth - day;

  double? get versusPrevious => hasPrevious && previousSameDay > 0 ? spent / previousSameDay - 1 : null;

  CategoryStats categoryOf(String key) => perCategory[key] ?? CategoryStats(categoryKey: key);
}
