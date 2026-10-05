import 'package:depenses/layers/functional/Expenses/domain/entities/default_labels.dart';
import 'package:depenses/layers/functional/Expenses/domain/entities/label_usage.dart';
import 'package:depenses/layers/functional/Expenses/domain/gateways/expense_gateway.dart';
import 'package:depenses/layers/functional/Expenses/domain/use_cases/add_label_use_case.dart';
import 'package:depenses/layers/functional/Expenses/domain/use_cases/get_label_usage_use_case.dart';
import 'package:depenses/layers/functional/Expenses/domain/use_cases/get_labels_use_case.dart';
import 'package:depenses/layers/functional/Expenses/domain/use_cases/remove_label_use_case.dart';
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

  group('AddLabelUseCase', () {
    test('appends a trimmed unknown label once', () async {
      final add = dependencies.get<AddLabelUseCase>();

      expect(await add('  Bébé '), 'Bébé');
      await add('Bébé');

      expect(dependencies.get<GetLabelsUseCase>()(), [...defaultLabels, 'Bébé']);
    });

    test('ignores a blank label', () async {
      expect(await dependencies.get<AddLabelUseCase>()('   '), isNull);
      expect(dependencies.store.writes, 0);
    });
  });

  group('GetLabelUsageUseCase', () {
    test('counts the expenses using each label', () async {
      await seedExpense(dependencies, name: 'Resto', labels: ['Amis', 'Sortie']);
      await seedExpense(dependencies, name: 'Bar', labels: ['Amis']);

      final usage = dependencies.get<GetLabelUsageUseCase>()();

      expect(usage.first, const LabelUsage(label: 'Sortie', expenseCount: 1));
      expect(usage[1], const LabelUsage(label: 'Amis', expenseCount: 2));
      expect(usage.last, const LabelUsage(label: 'Sport', expenseCount: 0));
    });
  });

  group('RemoveLabelUseCase', () {
    test('forgets the label and strips it from expenses and recurrences', () async {
      final expense = await seedExpense(dependencies, name: 'Resto', labels: ['Amis', 'Sortie']);
      await dependencies.get<RecurrenceGateway>().add(
        Recurrence(
          id: 'r1',
          name: 'Club',
          amount: 20,
          categoryKey: 'san',
          frequency: Frequency.month,
          start: DateTime(2026),
          labels: const ['Amis'],
        ),
      );

      await dependencies.get<RemoveLabelUseCase>()('Amis');

      expect(dependencies.get<GetLabelsUseCase>()(), isNot(contains('Amis')));
      expect(dependencies.get<ExpenseGateway>().all().single.labels, ['Sortie']);
      expect(dependencies.get<ExpenseGateway>().all().single.id, expense.id);
      expect(dependencies.get<RecurrenceGateway>().byId('r1')!.labels, isEmpty);
    });
  });
}
