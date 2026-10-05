import '../entities/expense.dart';
import '../gateways/expense_gateway.dart';

class GetMonthExpensesUseCase {
  GetMonthExpensesUseCase(this._expenses);

  final ExpenseGateway _expenses;

  List<Expense> call(DateTime month) => _expenses.inMonth(month);
}
