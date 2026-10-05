import '../entities/expense.dart';
import '../gateways/expense_gateway.dart';

class GetAllExpensesUseCase {
  GetAllExpensesUseCase(this._expenses);

  final ExpenseGateway _expenses;

  List<Expense> call() => _expenses.all();
}
