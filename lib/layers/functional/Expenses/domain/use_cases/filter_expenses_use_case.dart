import 'package:depenses/layers/technical/TextMatching/normalize_for_matching.dart';

import '../entities/described_expense.dart';
import '../entities/expense_kind_filter.dart';
import '../entities/expense_query.dart';

class FilterExpensesUseCase {
  const FilterExpensesUseCase();

  List<DescribedExpense> call(
    List<DescribedExpense> expenses,
    ExpenseQuery query, {
    required String Function(double amount) amountLabel,
  }) {
    final text = normalizeForMatching(query.text);
    final matching = expenses.where((item) {
      final expense = item.expense;
      if (query.kind == ExpenseKindFilter.recurring && !expense.isRecurring) return false;
      if (query.kind == ExpenseKindFilter.occasional && expense.isRecurring) return false;
      if (query.categoryKey != null && expense.categoryKey != query.categoryKey) return false;
      if (text.isEmpty) return true;
      final searchable = [
        expense.name,
        expense.labels.join(' '),
        item.category.name,
        amountLabel(expense.amount),
        '${expense.amount}',
      ].join(' ');
      return normalizeForMatching(searchable).contains(text);
    }).toList();
    return matching..sort((a, b) {
      final byDate = b.expense.date.compareTo(a.expense.date);
      return byDate != 0 ? byDate : b.expense.id.compareTo(a.expense.id);
    });
  }
}
