import 'package:depenses/layers/functional/Expenses/domain/entities/expense.dart';

class MonthTotals {
  MonthTotals._(int daysInMonth) : daily = List<double>.filled(daysInMonth, 0);

  factory MonthTotals.current(List<Expense> expenses, DateTime today, String Function(String) keyOf) {
    final totals = MonthTotals._(DateTime(today.year, today.month + 1, 0).day);
    for (final expense in expenses.where((e) => !e.date.isAfter(today))) {
      final key = keyOf(expense.categoryKey);
      totals.total += expense.amount;
      totals.perCategory.update(key, (sum) => sum + expense.amount, ifAbsent: () => expense.amount);
      if (expense.isRecurring) {
        totals.recurring += expense.amount;
      } else {
        totals.occasional += expense.amount;
        totals.occasionalPerCategory.update(key, (sum) => sum + expense.amount, ifAbsent: () => expense.amount);
      }
      totals.daily[expense.date.day - 1] += expense.amount;
    }
    return totals;
  }

  factory MonthTotals.previous(
    List<Expense> expenses, {
    required int sameDay,
    required int daysInMonth,
    required String Function(String) keyOf,
  }) {
    final totals = MonthTotals._(daysInMonth)..hasExpenses = expenses.isNotEmpty;
    for (final expense in expenses) {
      totals.total += expense.amount;
      totals.daily[expense.date.day - 1] += expense.amount;
      if (expense.date.day > sameDay) continue;
      totals.sameDayTotal += expense.amount;
      totals.sameDayPerCategory.update(
        keyOf(expense.categoryKey),
        (sum) => sum + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }
    return totals;
  }

  final List<double> daily;
  final Map<String, double> perCategory = {};
  final Map<String, double> occasionalPerCategory = {};
  final Map<String, double> sameDayPerCategory = {};
  double total = 0;
  double recurring = 0;
  double occasional = 0;
  double sameDayTotal = 0;
  bool hasExpenses = false;
}
