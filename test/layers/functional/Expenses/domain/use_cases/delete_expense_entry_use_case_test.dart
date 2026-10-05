import 'package:depenses/layers/functional/Expenses/domain/gateways/expense_gateway.dart';
import 'package:depenses/layers/functional/Expenses/domain/use_cases/delete_expense_entry_use_case.dart';
import 'package:depenses/layers/functional/Recurrences/domain/entities/frequency.dart';
import 'package:depenses/layers/functional/Recurrences/domain/entities/recurrence.dart';
import 'package:depenses/layers/functional/Recurrences/domain/gateways/recurrence_gateway.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';
import '../../expenses_seed.dart';

void main() {
  late TestDependencies dependencies;

  setUp(() => dependencies = TestDependencies());
  tearDown(() => dependencies.dispose());

  test('deletes the edited expense', () async {
    final expense = await seedExpense(dependencies, name: 'Pain');

    await dependencies.get<DeleteExpenseEntryUseCase>()(expense: expense);

    expect(dependencies.get<ExpenseGateway>().all(), isEmpty);
  });

  test('deletes the edited recurrence and keeps past expenses', () async {
    final recurrence = Recurrence(
      id: 'r1',
      name: 'Club',
      amount: 20,
      categoryKey: 'san',
      frequency: Frequency.month,
      start: DateTime(2026),
    );
    await dependencies.get<RecurrenceGateway>().add(recurrence);
    await seedExpense(dependencies, name: 'Club');

    await dependencies.get<DeleteExpenseEntryUseCase>()(recurrence: recurrence);

    expect(dependencies.get<RecurrenceGateway>().all(), isEmpty);
    expect(dependencies.get<ExpenseGateway>().all(), hasLength(1));
  });
}
