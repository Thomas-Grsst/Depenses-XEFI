import 'package:depenses/layers/functional/Savings/domain/use_cases/get_rounded_expenses_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';
import '../../savings_seed.dart';

void main() {
  late TestDependencies dependencies;

  tearDown(() => dependencies.dispose());

  test('lists only the rounded expenses, newest first then by descending id', () {
    dependencies = TestDependencies(
      data: {
        'expenses': [
          savingsExpense('a', 'Pain', 1.2, '2026-10-01', roundUp: 0.8),
          savingsExpense('b', 'Loyer', 800, '2026-10-05'),
          savingsExpense('c', 'Café', 2.5, '2026-10-05', roundUp: 0.5),
          savingsExpense('d', 'Livre', 12.3, '2026-10-05', roundUp: 0.7),
          savingsExpense('e', 'Cinéma', 9.5, '2026-09-28', roundUp: 0.5),
        ],
      },
    );

    final rounded = dependencies.get<GetRoundedExpensesUseCase>()();

    expect(rounded.map((e) => e.id), ['d', 'c', 'a', 'e']);
  });
}
