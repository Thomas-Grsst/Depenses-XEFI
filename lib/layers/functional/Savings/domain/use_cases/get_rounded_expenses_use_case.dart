import 'package:depenses/layers/functional/Expenses/domain/entities/expense.dart';
import 'package:depenses/layers/functional/Expenses/domain/gateways/expense_gateway.dart';

class GetRoundedExpensesUseCase {
  GetRoundedExpensesUseCase(this._expenses);

  final ExpenseGateway _expenses;

  List<Expense> call() => _expenses.all().where((e) => e.roundUp > 0).toList()..sort(_newestFirst);

  static int _newestFirst(Expense a, Expense b) {
    final byDate = b.date.compareTo(a.date);
    return byDate != 0 ? byDate : b.id.compareTo(a.id);
  }
}
