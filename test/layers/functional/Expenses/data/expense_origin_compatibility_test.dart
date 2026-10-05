import 'package:depenses/layers/functional/Expenses/data/models/expense_model.dart';
import 'package:depenses/layers/functional/Expenses/domain/entities/expense.dart';
import 'package:depenses/layers/functional/Expenses/domain/entities/expense_origin.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('an expense stored without origin is read as a manual expense', () {
    final expense = ExpenseModel.fromJson({
      'id': 'a',
      'name': 'Café',
      'amount': 2.5,
      'date': '2026-10-01',
      'cat': 'ali',
      'labels': <String>[],
    });

    expect(expense.origin, ExpenseOrigin.manual);
    expect(expense.bankTransactionId, isNull);
    expect(ExpenseModel.toJson(expense).containsKey('origin'), isFalse);
  });

  test('an imported expense keeps its origin and bank transaction id', () {
    final imported = Expense(
      id: 'b',
      name: 'Carrefour',
      amount: 12.4,
      date: DateTime(2026, 10, 3),
      categoryKey: 'ali',
      origin: ExpenseOrigin.bank,
      bankTransactionId: 'tx-1',
    );

    final json = ExpenseModel.toJson(imported);

    expect(json['origin'], 'bank');
    expect(json['bankTxId'], 'tx-1');
    expect(ExpenseModel.fromJson(json), imported);
  });
}
