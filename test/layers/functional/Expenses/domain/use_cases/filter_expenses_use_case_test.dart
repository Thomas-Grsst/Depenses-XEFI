import 'package:depenses/layers/functional/Expenses/domain/entities/described_expense.dart';
import 'package:depenses/layers/functional/Expenses/domain/entities/expense_kind_filter.dart';
import 'package:depenses/layers/functional/Expenses/domain/entities/expense_query.dart';
import 'package:depenses/layers/functional/Expenses/domain/use_cases/describe_expenses_use_case.dart';
import 'package:depenses/layers/functional/Expenses/domain/use_cases/filter_expenses_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';
import '../../expenses_seed.dart';

String _commaAmount(double amount) => amount.toStringAsFixed(2).replaceAll('.', ',');

void main() {
  late TestDependencies dependencies;
  late List<DescribedExpense> expenses;
  const filter = FilterExpensesUseCase();

  setUp(() async {
    dependencies = TestDependencies();
    final today = dependencies.clock.today();
    final cinema = await seedExpense(dependencies, name: 'Cinéma', amount: 12.5, categoryKey: 'loi', labels: ['Amis']);
    final rent = await seedRecurringExpense(dependencies, name: 'Loyer', date: DateTime(today.year, today.month, 1));
    final bread = await seedExpense(
      dependencies,
      name: 'Pain',
      amount: 1.2,
      date: DateTime(today.year, today.month, 3),
    );
    expenses = dependencies.get<DescribeExpensesUseCase>()([rent, cinema, bread]);
  });
  tearDown(() => dependencies.dispose());

  List<String> names(ExpenseQuery query) =>
      filter(expenses, query, amountLabel: _commaAmount).map((d) => d.expense.name).toList();

  test('sorts by date then id, newest first', () {
    expect(names(const ExpenseQuery()), ['Cinéma', 'Pain', 'Loyer']);
  });

  test('keeps recurring or occasional expenses only', () {
    expect(names(const ExpenseQuery(kind: ExpenseKindFilter.recurring)), ['Loyer']);
    expect(names(const ExpenseQuery(kind: ExpenseKindFilter.occasional)), ['Cinéma', 'Pain']);
  });

  test('keeps the selected category only', () {
    expect(names(const ExpenseQuery(categoryKey: 'loi')), ['Cinéma']);
  });

  test('matches text on name, label, category and amount without accents', () {
    expect(names(const ExpenseQuery(text: 'cinema')), ['Cinéma']);
    expect(names(const ExpenseQuery(text: 'amis')), ['Cinéma']);
    expect(names(const ExpenseQuery(text: 'loisirs')), ['Cinéma']);
    expect(names(const ExpenseQuery(text: '12,50')), ['Cinéma']);
    expect(names(const ExpenseQuery(text: '1.2')), ['Pain']);
  });
}
