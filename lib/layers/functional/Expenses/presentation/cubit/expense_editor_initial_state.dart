import 'package:depenses/layers/functional/Recurrences/domain/entities/frequency.dart';

import 'expense_editor_state.dart';
import 'expense_editor_target.dart';

const _defaultCategoryKey = 'ali';

ExpenseEditorState initialExpenseEditorState(ExpenseEditorTarget target, DateTime today) {
  final expense = target.expense;
  final recurrence = target.recurrence;
  final isEditing = expense != null || recurrence != null;
  return ExpenseEditorState(
    target: target,
    today: today,
    date: expense?.date ?? recurrence?.start ?? today,
    categoryKey: expense?.categoryKey ?? recurrence?.categoryKey ?? _defaultCategoryKey,
    isRecurring: recurrence != null || target.startsRecurring,
    frequency: recurrence?.frequency ?? Frequency.month,
    name: expense?.name ?? recurrence?.name ?? '',
    amount: expense?.amount ?? recurrence?.amount,
    labels: {...?expense?.labels, ...?recurrence?.labels}.toList(),
    isCategoryTouched: isEditing,
  );
}
