import 'package:depenses/layers/functional/Recurrences/domain/entities/recurrence.dart';
import 'package:depenses/layers/functional/Recurrences/domain/use_cases/delete_recurrence_use_case.dart';

import '../entities/expense.dart';
import 'delete_expense_use_case.dart';

class DeleteExpenseEntryUseCase {
  DeleteExpenseEntryUseCase(this._deleteExpense, this._deleteRecurrence);

  final DeleteExpenseUseCase _deleteExpense;
  final DeleteRecurrenceUseCase _deleteRecurrence;

  Future<void> call({Expense? expense, Recurrence? recurrence}) async {
    if (expense != null) return _deleteExpense(expense.id);
    if (recurrence != null) return _deleteRecurrence(recurrence.id);
  }
}
