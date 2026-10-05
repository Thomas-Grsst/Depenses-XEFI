import 'package:depenses/layers/functional/Categories/domain/use_cases/get_category_use_case.dart';
import 'package:depenses/layers/functional/Recurrences/domain/entities/recurrence_draft.dart';
import 'package:depenses/layers/functional/Recurrences/domain/use_cases/add_recurrence_use_case.dart';
import 'package:depenses/layers/functional/Recurrences/domain/use_cases/update_recurrence_use_case.dart';

import '../entities/expense_draft.dart';
import '../entities/expense_entry.dart';
import '../entities/expense_entry_outcome.dart';
import 'add_expense_use_case.dart';
import 'update_expense_use_case.dart';

class SaveExpenseEntryUseCase {
  SaveExpenseEntryUseCase(
    this._addExpense,
    this._updateExpense,
    this._addRecurrence,
    this._updateRecurrence,
    this._getCategory,
  );

  final AddExpenseUseCase _addExpense;
  final UpdateExpenseUseCase _updateExpense;
  final AddRecurrenceUseCase _addRecurrence;
  final UpdateRecurrenceUseCase _updateRecurrence;
  final GetCategoryUseCase _getCategory;

  Future<ExpenseEntryOutcome> call(ExpenseEntry entry) async {
    final trimmed = entry.name.trim();
    final name = trimmed.isEmpty ? _getCategory(entry.categoryKey).name : trimmed;
    final expense = entry.expense;
    final recurrence = entry.recurrence;
    if (expense != null) {
      await _updateExpense(
        expense.copyWith(
          name: name,
          amount: entry.amount,
          date: entry.date,
          categoryKey: entry.categoryKey,
          labels: entry.labels,
        ),
      );
      return ExpenseEntryOutcome.expenseUpdated;
    }
    if (recurrence != null) {
      await _updateRecurrence(
        recurrence.copyWith(
          name: name,
          amount: entry.amount,
          categoryKey: entry.categoryKey,
          frequency: entry.frequency,
          start: entry.date,
          labels: entry.labels,
        ),
      );
      return ExpenseEntryOutcome.recurrenceUpdated;
    }
    if (entry.isRecurring) {
      await _addRecurrence(
        RecurrenceDraft(
          name: name,
          amount: entry.amount,
          categoryKey: entry.categoryKey,
          frequency: entry.frequency,
          start: entry.date,
          labels: entry.labels,
        ),
      );
      return ExpenseEntryOutcome.recurrenceCreated;
    }
    await _addExpense(
      ExpenseDraft(
        name: name,
        amount: entry.amount,
        date: entry.date,
        categoryKey: entry.categoryKey,
        labels: entry.labels,
      ),
    );
    return ExpenseEntryOutcome.expenseCreated;
  }
}
