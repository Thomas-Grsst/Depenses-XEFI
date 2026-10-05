import 'package:depenses/layers/functional/Categories/domain/gateways/category_gateway.dart';
import 'package:depenses/layers/functional/Expenses/domain/entities/expense.dart';
import 'package:depenses/layers/functional/Expenses/domain/gateways/expense_gateway.dart';
import 'package:depenses/layers/technical/Calendar/calendar_day.dart';
import 'package:depenses/layers/technical/Calendar/clock.dart';

import '../entities/category_move.dart';
import '../entities/month_comparison.dart';

class CompareMonthsUseCase {
  CompareMonthsUseCase(this._expenses, this._categories, this._clock);

  final ExpenseGateway _expenses;
  final CategoryGateway _categories;
  final Clock _clock;

  MonthComparison call({DateTime? referenceMonth, required bool isToDate}) {
    final today = _clock.today();
    final reference = (referenceMonth ?? DateTime(today.year, today.month - 1)).firstOfMonth;
    final current = _expenses.inMonth(today.firstOfMonth).where((e) => !e.date.isAfter(today));
    final referenceExpenses = _expenses.inMonth(reference);
    final counted = referenceExpenses.where((e) => !isToDate || e.date.day <= today.day);
    final currentPerCategory = _totalsPerCategory(current);
    final referencePerCategory = _totalsPerCategory(counted);
    return MonthComparison(
      today: today,
      referenceMonth: reference,
      isToDate: isToDate,
      currentTotal: _total(current),
      referenceTotal: _total(counted),
      hasReferenceData: referenceExpenses.isNotEmpty,
      moves: [
        for (final category in _categories.all())
          if ((currentPerCategory[category.key] ?? 0) > 0 || (referencePerCategory[category.key] ?? 0) > 0)
            CategoryMove(
              categoryKey: category.key,
              current: currentPerCategory[category.key] ?? 0,
              previous: referencePerCategory[category.key] ?? 0,
            ),
      ],
    );
  }

  static double _total(Iterable<Expense> expenses) => expenses.fold(0.0, (total, e) => total + e.amount);

  static Map<String, double> _totalsPerCategory(Iterable<Expense> expenses) {
    final totals = <String, double>{};
    for (final expense in expenses) {
      totals.update(expense.categoryKey, (sum) => sum + expense.amount, ifAbsent: () => expense.amount);
    }
    return totals;
  }
}
