import 'package:depenses/layers/functional/Recurrences/domain/entities/frequency.dart';
import 'package:depenses/layers/functional/Recurrences/domain/entities/recurrence.dart';
import 'package:equatable/equatable.dart';

import 'expense.dart';

class ExpenseEntry extends Equatable {
  const ExpenseEntry({
    required this.name,
    required this.amount,
    required this.date,
    required this.categoryKey,
    required this.labels,
    required this.isRecurring,
    required this.frequency,
    this.expense,
    this.recurrence,
  });

  final String name;
  final double amount;
  final DateTime date;
  final String categoryKey;
  final List<String> labels;
  final bool isRecurring;
  final Frequency frequency;
  final Expense? expense;
  final Recurrence? recurrence;

  @override
  List<Object?> get props => [name, amount, date, categoryKey, labels, isRecurring, frequency, expense, recurrence];
}
