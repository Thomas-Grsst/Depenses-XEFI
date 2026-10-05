import '../gateways/expense_deletion_listener.dart';
import '../gateways/expense_gateway.dart';

class DeleteExpenseUseCase {
  DeleteExpenseUseCase(this._expenses, this._deletionListener);

  final ExpenseGateway _expenses;
  final ExpenseDeletionListener _deletionListener;

  Future<void> call(String id) async {
    final deleted = _expenses.all().where((expense) => expense.id == id).firstOrNull;
    await _expenses.delete(id);
    if (deleted != null) await _deletionListener(deleted);
  }
}
