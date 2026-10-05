import 'package:depenses/layers/functional/Expenses/domain/gateways/expense_gateway.dart';
import 'package:depenses/layers/functional/Recurrences/domain/gateways/recurrence_gateway.dart';
import 'package:depenses/layers/functional/Recurrences/domain/use_cases/accept_suggestion_use_case.dart';
import 'package:depenses/layers/functional/Recurrences/domain/use_cases/detect_recurring_expenses_use_case.dart';
import 'package:depenses/layers/functional/Recurrences/domain/use_cases/ignore_suggestion_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';

Map<String, dynamic> _expense(String id, String name, double amount, String date) => {
  'id': id,
  'name': name,
  'amount': amount,
  'date': date,
  'cat': 'loi',
  'labels': <String>[],
};

void main() {
  late TestDependencies dependencies;

  setUp(() {
    dependencies = TestDependencies(
      today: DateTime(2026, 10, 15),
      data: {
        'expenses': [
          _expense('a', 'Spotify', 10.99, '2026-08-03'),
          _expense('b', 'spotify ', 10.99, '2026-09-04'),
          _expense('c', 'Spotify', 10.99, '2026-10-03'),
          _expense('d', 'Boulangerie', 4.2, '2026-10-02'),
          _expense('e', 'Boulangerie', 3.1, '2026-10-09'),
        ],
      },
    );
  });
  tearDown(() => dependencies.dispose());

  test('a same amount paid once a month around the same day is suggested', () {
    final suggestion = dependencies.get<DetectRecurringExpensesUseCase>()().single;

    expect(suggestion.key, 'spotify');
    expect(suggestion.months, 3);
    expect(suggestion.expenseIds, ['a', 'b', 'c']);
  });

  test('accepting a suggestion creates a monthly recurrence linked to its expenses', () async {
    final suggestion = dependencies.get<DetectRecurringExpensesUseCase>()().single;

    final recurrence = await dependencies.get<AcceptSuggestionUseCase>()(suggestion);

    expect(dependencies.get<RecurrenceGateway>().all().single.id, recurrence.id);
    expect(dependencies.get<ExpenseGateway>().all().where((e) => e.recurrenceId == recurrence.id), hasLength(3));
    expect(dependencies.get<DetectRecurringExpensesUseCase>()(), isEmpty);
  });

  test('an ignored suggestion is not proposed again', () async {
    final suggestion = dependencies.get<DetectRecurringExpensesUseCase>()().single;

    await dependencies.get<IgnoreSuggestionUseCase>()(suggestion);

    expect(dependencies.get<DetectRecurringExpensesUseCase>()(), isEmpty);
  });
}
