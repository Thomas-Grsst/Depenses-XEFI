import 'package:depenses/layers/functional/Budget/domain/use_cases/set_envelope_use_case.dart';
import 'package:depenses/layers/functional/Expenses/domain/entities/expense_entry_outcome.dart';
import 'package:depenses/layers/functional/Expenses/domain/gateways/expense_gateway.dart';
import 'package:depenses/layers/functional/Expenses/presentation/cubit/expense_editor_cubit.dart';
import 'package:depenses/layers/functional/Expenses/presentation/cubit/expense_editor_status.dart';
import 'package:depenses/layers/functional/Expenses/presentation/cubit/expense_editor_target.dart';
import 'package:depenses/layers/functional/Recurrences/domain/entities/frequency.dart';
import 'package:depenses/layers/functional/Recurrences/domain/gateways/recurrence_gateway.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';
import '../../expenses_seed.dart';

void main() {
  late TestDependencies dependencies;

  setUp(() => dependencies = TestDependencies(today: DateTime(2026, 10, 15)));
  tearDown(() => dependencies.dispose());

  ExpenseEditorCubit buildCubit([ExpenseEditorTarget target = const ExpenseEditorTarget()]) =>
      dependencies.getIt<ExpenseEditorCubit>(param1: target);

  test('starts a new occasional expense today in Alimentation', () async {
    final cubit = buildCubit();

    expect(cubit.state.date, DateTime(2026, 10, 15));
    expect(cubit.state.categoryKey, 'ali');
    expect(cubit.state.isRecurring, isFalse);
    expect(cubit.state.isEditing, isFalse);
    expect(cubit.state.canSave, isFalse);
    expect(cubit.state.allLabels, contains('Sortie'));
    await cubit.close();
  });

  test('guesses the category from the name until a category is picked', () async {
    final cubit = buildCubit()..changeName('SNCF Paris');

    expect(cubit.state.categoryKey, 'tra');
    expect(cubit.state.look?.icon, 'train');
    cubit
      ..selectCategory('loi')
      ..changeName('Carrefour');
    expect(cubit.state.categoryKey, 'loi');
    await cubit.close();
  });

  test('previews the round-up and creates the expense', () async {
    final cubit = buildCubit()
      ..changeName('Pain')
      ..changeAmount(8.37);

    expect(cubit.state.roundUpPreview, closeTo(0.63, 1e-9));
    await cubit.save();

    expect(cubit.state.status, ExpenseEditorStatus.saved);
    expect(cubit.state.outcome, ExpenseEntryOutcome.expenseCreated);
    expect(dependencies.get<ExpenseGateway>().all().single.roundUp, closeTo(0.63, 1e-9));
    await cubit.close();
  });

  test('creates a recurrence with its next occurrence', () async {
    final cubit = buildCubit(const ExpenseEditorTarget(startsRecurring: true))
      ..changeAmount(9.99)
      ..selectFrequency(Frequency.year)
      ..changeDate(DateTime(2026, 3, 1, 10));

    expect(cubit.state.roundUpPreview, 0);
    expect(cubit.state.nextOccurrence, DateTime(2027, 3, 1));
    await cubit.save();

    expect(cubit.state.outcome, ExpenseEntryOutcome.recurrenceCreated);
    expect(dependencies.get<RecurrenceGateway>().all().single.frequency, Frequency.year);
    await cubit.close();
  });

  test('edits then deletes an existing expense', () async {
    final expense = await seedExpense(dependencies, name: 'Resto', amount: 30, labels: ['Amis']);
    final cubit = buildCubit(ExpenseEditorTarget(expense: expense));

    expect(cubit.state.isCategoryTouched, isTrue);
    expect(cubit.state.labels, ['Amis']);
    expect(cubit.state.canSave, isTrue);
    await cubit.delete();

    expect(cubit.state.status, ExpenseEditorStatus.deleted);
    expect(dependencies.get<ExpenseGateway>().all(), isEmpty);
    await cubit.close();
  });

  test('adds and toggles labels', () async {
    final cubit = buildCubit();

    await cubit.addLabel(' Bébé ');
    expect(cubit.state.labels, ['Bébé']);
    expect(cubit.state.knownLabels, contains('Bébé'));
    cubit.toggleLabel('Bébé');
    expect(cubit.state.labels, isEmpty);
    await cubit.close();
  });

  test('shows the envelope of the selected category', () async {
    await dependencies.get<SetEnvelopeUseCase>()('loi', 100);
    final cubit = buildCubit()..selectCategory('loi');

    expect(cubit.state.categoryStats?.budget, 100);
    expect(cubit.state.category.name, 'Loisirs');
    await cubit.close();
  });
}
