import 'package:depenses/layers/functional/Expenses/domain/entities/expense_kind_filter.dart';
import 'package:depenses/layers/functional/Expenses/presentation/cubit/expenses_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';
import '../../expenses_seed.dart';

String _amountLabel(double amount) => amount.toStringAsFixed(2).replaceAll('.', ',');

void main() {
  late TestDependencies dependencies;

  setUp(() async {
    dependencies = TestDependencies(today: DateTime(2026, 10, 15));
    await seedExpense(dependencies, name: 'Cinéma', amount: 12.5, categoryKey: 'loi');
    await seedExpense(dependencies, name: 'Pain', amount: 1.5, date: DateTime(2026, 10, 3));
    await seedRecurringExpense(dependencies, name: 'Loyer', date: DateTime(2026, 10, 1));
    await seedExpense(dependencies, name: 'Train', amount: 40, date: DateTime(2026, 9, 20), categoryKey: 'tra');
  });
  tearDown(() => dependencies.dispose());

  ExpensesCubit buildCubit() => dependencies.getIt<ExpensesCubit>(param1: _amountLabel);

  List<String> visibleNames(ExpensesCubit cubit) => cubit.state.visibleExpenses.map((e) => e.expense.name).toList();

  test('loads the current month grouped by day, newest first', () async {
    final cubit = buildCubit();

    expect(cubit.state.month, DateTime(2026, 10));
    expect(visibleNames(cubit), ['Cinéma', 'Pain', 'Loyer']);
    expect(cubit.state.visibleTotal, 24);
    expect(cubit.state.days.map((d) => d.day), [DateTime(2026, 10, 15), DateTime(2026, 10, 3), DateTime(2026, 10, 1)]);
    expect(cubit.state.months.map((m) => m.month), [DateTime(2026, 10), DateTime(2026, 9)]);
    expect(cubit.state.categories.last.key, 'aut');
    await cubit.close();
  });

  test('filters by kind, category and text', () async {
    final cubit = buildCubit();

    cubit.selectKind(ExpenseKindFilter.recurring);
    expect(visibleNames(cubit), ['Loyer']);
    cubit
      ..selectKind(ExpenseKindFilter.all)
      ..toggleCategory('loi');
    expect(visibleNames(cubit), ['Cinéma']);
    cubit
      ..toggleCategory('loi')
      ..search('pain');
    expect(visibleNames(cubit), ['Pain']);
    expect(cubit.state.hasMonthExpenses, isTrue);
    await cubit.close();
  });

  test('switches month and keeps the filters', () async {
    final cubit = buildCubit()..toggleCategory('tra');

    cubit.selectMonth(DateTime(2026, 9, 12));

    expect(cubit.state.month, DateTime(2026, 9));
    expect(visibleNames(cubit), ['Train']);
    expect(cubit.state.isCurrentYear, isTrue);
    await cubit.close();
  });

  test('reloads when the ledger changes', () async {
    final cubit = buildCubit();

    await seedExpense(dependencies, name: 'Café', amount: 2);

    expect(visibleNames(cubit), contains('Café'));
    await cubit.close();
  });
}
