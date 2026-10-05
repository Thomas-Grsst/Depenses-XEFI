import '../entities/label_usage.dart';
import '../gateways/expense_gateway.dart';
import '../gateways/label_gateway.dart';

class GetLabelUsageUseCase {
  GetLabelUsageUseCase(this._labels, this._expenses);

  final LabelGateway _labels;
  final ExpenseGateway _expenses;

  List<LabelUsage> call() {
    final expenses = _expenses.all();
    return [
      for (final label in _labels.all())
        LabelUsage(label: label, expenseCount: expenses.where((e) => e.labels.contains(label)).length),
    ];
  }
}
