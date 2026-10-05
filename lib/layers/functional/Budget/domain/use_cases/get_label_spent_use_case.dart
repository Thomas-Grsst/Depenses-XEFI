import 'package:depenses/layers/functional/Expenses/domain/gateways/expense_gateway.dart';

class GetLabelSpentUseCase {
  GetLabelSpentUseCase(this._expenses);

  final ExpenseGateway _expenses;

  double call(String label, DateTime month) =>
      _expenses.inMonth(month).where((e) => e.labels.contains(label)).fold(0.0, (total, e) => total + e.amount);
}
