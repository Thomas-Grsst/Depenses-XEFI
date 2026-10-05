import 'package:depenses/layers/functional/Expenses/domain/gateways/expense_gateway.dart';
import 'package:depenses/layers/functional/Recurrences/domain/entities/frequency.dart';
import 'package:depenses/layers/functional/Recurrences/domain/entities/recurrence_draft.dart';
import 'package:depenses/layers/functional/Recurrences/domain/gateways/recurrence_gateway.dart';
import 'package:depenses/layers/functional/Recurrences/domain/use_cases/add_recurrence_use_case.dart';
import 'package:depenses/layers/functional/Recurrences/domain/use_cases/materialize_due_recurrences_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';

void main() {
  late TestDependencies dependencies;

  setUp(() => dependencies = TestDependencies(today: DateTime(2026, 10, 15)));
  tearDown(() => dependencies.dispose());

  Future<void> addRent(DateTime start) => dependencies.get<AddRecurrenceUseCase>()(
    RecurrenceDraft(name: 'Loyer', amount: 800, categoryKey: 'log', frequency: Frequency.month, start: start),
  );

  test('adding a recurrence creates the expenses of its past occurrences', () async {
    await addRent(DateTime(2026, 8, 5));

    final expenses = dependencies.get<ExpenseGateway>().all();
    expect(expenses.map((e) => e.date), [DateTime(2026, 8, 5), DateTime(2026, 9, 5), DateTime(2026, 10, 5)]);
    expect(expenses.every((e) => e.isRecurring && e.roundUp == 0), isTrue);
    expect(dependencies.get<RecurrenceGateway>().all().single.lastGeneratedOn, DateTime(2026, 10, 15));
  });

  test('materializing again on a later day only creates the new occurrences', () async {
    await addRent(DateTime(2026, 10, 5));
    dependencies.clock.current = DateTime(2026, 11, 20);

    await dependencies.get<MaterializeDueRecurrencesUseCase>()();
    await dependencies.get<MaterializeDueRecurrencesUseCase>()();

    expect(dependencies.get<ExpenseGateway>().all().map((e) => e.date), [DateTime(2026, 10, 5), DateTime(2026, 11, 5)]);
  });

  test('a future recurrence creates no expense yet', () async {
    await addRent(DateTime(2026, 10, 20));

    expect(dependencies.get<ExpenseGateway>().all(), isEmpty);
  });
}
