import 'package:depenses/layers/functional/Categories/domain/entities/category.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/described_expense.dart';
import '../../domain/entities/expense_query.dart';
import '../../domain/entities/month_spending.dart';
import 'expenses_day.dart';

class ExpensesState extends Equatable {
  const ExpensesState({
    required this.today,
    required this.month,
    this.query = const ExpenseQuery(),
    this.months = const [],
    this.categories = const [],
    this.monthExpenses = const [],
    this.visibleExpenses = const [],
  });

  final DateTime today;
  final DateTime month;
  final ExpenseQuery query;
  final List<MonthSpending> months;
  final List<Category> categories;
  final List<DescribedExpense> monthExpenses;
  final List<DescribedExpense> visibleExpenses;

  double get visibleTotal => visibleExpenses.fold(0.0, (total, item) => total + item.expense.amount);

  bool get hasMonthExpenses => monthExpenses.isNotEmpty;

  bool get isCurrentYear => month.year == today.year;

  List<ExpensesDay> get days {
    final byDay = <DateTime, List<DescribedExpense>>{};
    for (final item in visibleExpenses) {
      byDay.putIfAbsent(item.expense.date, () => []).add(item);
    }
    return [for (final entry in byDay.entries) ExpensesDay(day: entry.key, items: entry.value)];
  }

  ExpensesState copyWith({
    DateTime? today,
    DateTime? month,
    ExpenseQuery? query,
    List<MonthSpending>? months,
    List<Category>? categories,
    List<DescribedExpense>? monthExpenses,
    List<DescribedExpense>? visibleExpenses,
  }) => ExpensesState(
    today: today ?? this.today,
    month: month ?? this.month,
    query: query ?? this.query,
    months: months ?? this.months,
    categories: categories ?? this.categories,
    monthExpenses: monthExpenses ?? this.monthExpenses,
    visibleExpenses: visibleExpenses ?? this.visibleExpenses,
  );

  @override
  List<Object?> get props => [today, month, query, months, categories, monthExpenses, visibleExpenses];
}
