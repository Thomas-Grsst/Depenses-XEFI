import '../entities/expense.dart';
import '../gateways/expense_gateway.dart';

class GetRecentExpensesUseCase {
  GetRecentExpensesUseCase(this._expenses);

  final ExpenseGateway _expenses;

  List<Expense> call(int count) {
    final sorted = [..._expenses.all()]
      ..sort((a, b) {
        final byDate = b.date.compareTo(a.date);
        return byDate != 0 ? byDate : b.id.compareTo(a.id);
      });
    return sorted.take(count).toList();
  }
}
