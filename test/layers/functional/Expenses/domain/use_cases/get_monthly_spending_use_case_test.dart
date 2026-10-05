import 'package:depenses/layers/functional/Expenses/domain/entities/month_spending.dart';
import 'package:depenses/layers/functional/Expenses/domain/use_cases/get_monthly_spending_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';
import '../../expenses_seed.dart';

void main() {
  late TestDependencies dependencies;

  setUp(() => dependencies = TestDependencies(today: DateTime(2026, 10, 15)));
  tearDown(() => dependencies.dispose());

  test('totals every month with data, current month included, newest first', () async {
    await seedExpense(dependencies, name: 'A', amount: 10, date: DateTime(2026, 8, 2));
    await seedExpense(dependencies, name: 'B', amount: 5.5, date: DateTime(2026, 8, 20));

    final spending = dependencies.get<GetMonthlySpendingUseCase>()();

    expect(spending, [
      MonthSpending(month: DateTime(2026, 10), total: 0),
      MonthSpending(month: DateTime(2026, 8), total: 15.5),
    ]);
  });
}
