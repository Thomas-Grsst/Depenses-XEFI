import '../gateways/expense_gateway.dart';

class DeleteExpenseUseCase {
  DeleteExpenseUseCase(this._expenses);

  final ExpenseGateway _expenses;

  Future<void> call(String id) => _expenses.delete(id);
}
