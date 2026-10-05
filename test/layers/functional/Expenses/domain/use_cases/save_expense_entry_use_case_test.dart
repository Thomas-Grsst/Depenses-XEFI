import 'package:depenses/layers/functional/Expenses/domain/entities/expense.dart';
import 'package:depenses/layers/functional/Expenses/domain/entities/expense_entry.dart';
import 'package:depenses/layers/functional/Expenses/domain/entities/expense_entry_outcome.dart';
import 'package:depenses/layers/functional/Expenses/domain/gateways/expense_gateway.dart';
import 'package:depenses/layers/functional/Expenses/domain/use_cases/save_expense_entry_use_case.dart';
import 'package:depenses/layers/functional/Recurrences/domain/entities/frequency.dart';
import 'package:depenses/layers/functional/Recurrences/domain/entities/recurrence.dart';
import 'package:depenses/layers/functional/Recurrences/domain/gateways/recurrence_gateway.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';
import '../../expenses_seed.dart';

void main() {
  late TestDependencies dependencies;
  late SaveExpenseEntryUseCase save;

  setUp(() {
    dependencies = TestDependencies(today: DateTime(2026, 10, 15));
    save = dependencies.get<SaveExpenseEntryUseCase>();
  });
  tearDown(() => dependencies.dispose());

  ExpenseEntry entry({String name = 'Pain', bool isRecurring = false, Expense? expense, Recurrence? recurrence}) =>
      ExpenseEntry(
        name: name,
        amount: 4.2,
        date: DateTime(2026, 10, 14),
        categoryKey: 'ali',
        labels: const ['Maison'],
        isRecurring: isRecurring,
        frequency: Frequency.week,
        expense: expense,
        recurrence: recurrence,
      );

  test('creates an occasional expense named after the category when the name is blank', () async {
    expect(await save(entry(name: '  ')), ExpenseEntryOutcome.expenseCreated);

    final created = dependencies.get<ExpenseGateway>().all().single;
    expect(created.name, 'Alimentation');
    expect(created.labels, ['Maison']);
  });

  test('creates a recurrence', () async {
    expect(await save(entry(isRecurring: true)), ExpenseEntryOutcome.recurrenceCreated);

    final created = dependencies.get<RecurrenceGateway>().all().single;
    expect(created.frequency, Frequency.week);
    expect(created.start, DateTime(2026, 10, 14));
  });

  test('updates the edited expense', () async {
    final original = await seedExpense(dependencies, name: 'Old');

    expect(await save(entry(name: ' Pain ', expense: original)), ExpenseEntryOutcome.expenseUpdated);

    final updated = dependencies.get<ExpenseGateway>().all().single;
    expect(updated.id, original.id);
    expect(updated.name, 'Pain');
    expect(updated.amount, 4.2);
  });

  test('updates the edited recurrence', () async {
    final original = Recurrence(
      id: 'r1',
      name: 'Club',
      amount: 20,
      categoryKey: 'san',
      frequency: Frequency.month,
      start: DateTime(2026),
    );
    await dependencies.get<RecurrenceGateway>().add(original);

    expect(await save(entry(recurrence: original)), ExpenseEntryOutcome.recurrenceUpdated);

    final updated = dependencies.get<RecurrenceGateway>().byId('r1')!;
    expect(updated.name, 'Pain');
    expect(updated.frequency, Frequency.week);
    expect(updated.categoryKey, 'ali');
  });
}
