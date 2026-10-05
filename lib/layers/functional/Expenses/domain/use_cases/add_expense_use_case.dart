import 'package:depenses/layers/technical/Storage/id_generator.dart';

import '../entities/expense.dart';
import '../entities/expense_draft.dart';
import '../entities/round_up.dart';
import '../gateways/expense_gateway.dart';
import '../gateways/label_gateway.dart';
import '../gateways/round_up_setting_gateway.dart';

class AddExpenseUseCase {
  AddExpenseUseCase(this._expenses, this._labels, this._roundUp, this._ids);

  final ExpenseGateway _expenses;
  final LabelGateway _labels;
  final RoundUpSettingGateway _roundUp;
  final IdGenerator _ids;

  Future<Expense> call(ExpenseDraft draft) async {
    final expense = Expense(
      id: _ids.next(),
      name: draft.name,
      amount: draft.amount,
      date: draft.date,
      categoryKey: draft.categoryKey,
      labels: draft.labels,
      roundUp: _roundUp.isEnabled() ? roundUpOf(draft.amount) : 0,
    );
    await _labels.learn(expense.labels);
    await _expenses.add(expense);
    return expense;
  }
}
