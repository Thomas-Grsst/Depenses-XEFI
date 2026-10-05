import 'package:depenses/layers/functional/Expenses/domain/entities/expense.dart';
import 'package:depenses/layers/functional/Expenses/domain/entities/expense_draft.dart';
import 'package:depenses/layers/functional/Expenses/domain/gateways/expense_gateway.dart';
import 'package:depenses/layers/functional/Expenses/domain/use_cases/add_expense_use_case.dart';

import '../../../support/test_dependencies.dart';

Future<Expense> seedExpense(
  TestDependencies dependencies, {
  required String name,
  double amount = 10,
  DateTime? date,
  String categoryKey = 'ali',
  List<String> labels = const [],
}) => dependencies.get<AddExpenseUseCase>()(
  ExpenseDraft(
    name: name,
    amount: amount,
    date: date ?? dependencies.clock.today(),
    categoryKey: categoryKey,
    labels: labels,
  ),
);

Future<Expense> seedRecurringExpense(
  TestDependencies dependencies, {
  required String name,
  required DateTime date,
}) async {
  final expense = await seedExpense(dependencies, name: name, date: date);
  final gateway = dependencies.get<ExpenseGateway>();
  await gateway.linkToRecurrence([expense.id], 'rec');
  return gateway.all().firstWhere((e) => e.id == expense.id);
}
