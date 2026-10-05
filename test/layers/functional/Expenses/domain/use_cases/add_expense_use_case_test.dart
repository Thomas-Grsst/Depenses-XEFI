import 'package:depenses/layers/functional/Expenses/domain/entities/expense_draft.dart';
import 'package:depenses/layers/functional/Expenses/domain/entities/round_up.dart';
import 'package:depenses/layers/functional/Expenses/domain/gateways/expense_gateway.dart';
import 'package:depenses/layers/functional/Expenses/domain/gateways/label_gateway.dart';
import 'package:depenses/layers/functional/Expenses/domain/use_cases/add_expense_use_case.dart';
import 'package:depenses/layers/functional/Expenses/domain/use_cases/set_round_up_enabled_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';

void main() {
  late TestDependencies dependencies;

  setUp(() => dependencies = TestDependencies());
  tearDown(() => dependencies.dispose());

  ExpenseDraft draft(double amount, {List<String> labels = const []}) =>
      ExpenseDraft(name: 'Courses', amount: amount, date: DateTime(2026, 10, 15), categoryKey: 'ali', labels: labels);

  test('round-up sets aside the cents up to the next euro', () {
    expect(roundUpOf(8.37), closeTo(0.63, 0.0001));
    expect(roundUpOf(12), 0);
  });

  test('a new expense gets its round-up when the setting is enabled', () async {
    final expense = await dependencies.get<AddExpenseUseCase>()(draft(8.37));

    expect(expense.roundUp, closeTo(0.63, 0.0001));
    expect(dependencies.get<ExpenseGateway>().all().single.id, expense.id);
  });

  test('no round-up is set aside when the setting is disabled', () async {
    await dependencies.get<SetRoundUpEnabledUseCase>()(false);

    final expense = await dependencies.get<AddExpenseUseCase>()(draft(8.37));

    expect(expense.roundUp, 0);
  });

  test('unknown labels are learnt', () async {
    await dependencies.get<AddExpenseUseCase>()(draft(5, labels: ['Vacances']));

    expect(dependencies.get<LabelGateway>().all(), contains('Vacances'));
  });
}
