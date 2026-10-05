import 'package:depenses/layers/functional/Recurrences/domain/entities/recurrence.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/expense.dart';

class ExpenseEditorTarget extends Equatable {
  const ExpenseEditorTarget({this.expense, this.recurrence, this.startsRecurring = false});

  final Expense? expense;
  final Recurrence? recurrence;
  final bool startsRecurring;

  @override
  List<Object?> get props => [expense, recurrence, startsRecurring];
}
