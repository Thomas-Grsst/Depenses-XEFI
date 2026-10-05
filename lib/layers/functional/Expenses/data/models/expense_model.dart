import 'package:depenses/layers/technical/Storage/json_reading.dart';

import '../../domain/entities/expense.dart';

abstract final class ExpenseModel {
  static Expense fromJson(Map<String, dynamic> json) => Expense(
    id: json.text('id'),
    name: json.text('name'),
    amount: json.decimal('amount'),
    date: json.day('date'),
    categoryKey: json.text('cat'),
    labels: json.strings('labels'),
    recurrenceId: json.optionalText('recId'),
    roundUp: json.decimal('roundUp'),
  );

  static Map<String, dynamic> toJson(Expense expense) => {
    'id': expense.id,
    'name': expense.name,
    'amount': expense.amount,
    'date': encodeDay(expense.date),
    'cat': expense.categoryKey,
    'labels': expense.labels,
    'recId': expense.recurrenceId,
    'roundUp': expense.roundUp,
  };
}
