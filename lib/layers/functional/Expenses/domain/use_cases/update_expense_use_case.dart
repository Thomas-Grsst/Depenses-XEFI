import '../entities/expense.dart';
import '../entities/round_up.dart';
import '../gateways/expense_gateway.dart';
import '../gateways/label_gateway.dart';
import '../gateways/round_up_setting_gateway.dart';

class UpdateExpenseUseCase {
  UpdateExpenseUseCase(this._expenses, this._labels, this._roundUp);

  final ExpenseGateway _expenses;
  final LabelGateway _labels;
  final RoundUpSettingGateway _roundUp;

  Future<void> call(Expense expense) async {
    await _labels.learn(expense.labels);
    final recomputesRoundUp = expense.roundUp > 0 || (_roundUp.isEnabled() && !expense.isRecurring);
    if (!recomputesRoundUp) return _expenses.update(expense);
    final roundUp = expense.isRecurring ? 0.0 : roundUpOf(expense.amount);
    await _expenses.update(expense.copyWith(roundUp: roundUp));
  }
}
