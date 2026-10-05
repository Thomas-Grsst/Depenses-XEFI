import 'package:depenses/layers/functional/Expenses/domain/entities/expense.dart';
import 'package:depenses/layers/technical/Calendar/calendar_day.dart';

const historyMonths = 3;

class OccasionalHistory {
  OccasionalHistory(List<Expense> Function(DateTime month) expensesIn, DateTime month) {
    for (var offset = 1; offset <= historyMonths; offset++) {
      final past = DateTime(month.year, month.month - offset);
      final expenses = expensesIn(past);
      if (expenses.isEmpty) continue;
      days += past.daysInItsMonth;
      for (final expense in expenses.where((e) => !e.isRecurring)) {
        total += expense.amount;
        perCategory.update(expense.categoryKey, (sum) => sum + expense.amount, ifAbsent: () => expense.amount);
      }
    }
  }

  double total = 0;
  int days = 0;
  final Map<String, double> perCategory = {};
}
