import '../../domain/entities/expense.dart';
import '../../domain/gateways/expense_deletion_listener.dart';

class SilentExpenseDeletionListener implements ExpenseDeletionListener {
  const SilentExpenseDeletionListener();

  @override
  Future<void> call(Expense deleted) async {}
}
