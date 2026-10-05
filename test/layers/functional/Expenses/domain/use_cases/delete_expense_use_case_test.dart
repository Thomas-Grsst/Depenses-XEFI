import 'package:depenses/layers/functional/Expenses/domain/entities/expense.dart';
import 'package:depenses/layers/functional/Expenses/domain/gateways/expense_deletion_listener.dart';
import 'package:depenses/layers/functional/Expenses/domain/gateways/expense_gateway.dart';
import 'package:depenses/layers/functional/Expenses/domain/use_cases/delete_expense_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';
import '../../expenses_seed.dart';

class _RecordingDeletionListener implements ExpenseDeletionListener {
  final List<Expense> deleted = [];

  @override
  Future<void> call(Expense deleted) async => this.deleted.add(deleted);
}

void main() {
  late TestDependencies dependencies;

  setUp(() => dependencies = TestDependencies());
  tearDown(() => dependencies.dispose());

  test('deletes the expense without any listener bound', () async {
    final expense = await seedExpense(dependencies, name: 'Pain');

    await dependencies.get<DeleteExpenseUseCase>()(expense.id);

    expect(dependencies.get<ExpenseGateway>().all(), isEmpty);
  });

  test('tells the deletion listener which expense was deleted', () async {
    final listener = _RecordingDeletionListener();
    final expense = await seedExpense(dependencies, name: 'Pain');
    final deleteExpense = DeleteExpenseUseCase(dependencies.get(), listener);

    await deleteExpense(expense.id);
    await deleteExpense('unknown');

    expect(listener.deleted, [expense]);
  });
}
