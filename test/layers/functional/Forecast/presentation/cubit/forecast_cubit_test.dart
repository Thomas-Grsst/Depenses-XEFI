import 'package:depenses/layers/functional/Expenses/domain/gateways/expense_gateway.dart';
import 'package:depenses/layers/functional/Expenses/domain/entities/expense.dart';
import 'package:depenses/layers/functional/Forecast/domain/entities/recurrence_tally.dart';
import 'package:depenses/layers/functional/Forecast/presentation/cubit/forecast_cubit.dart';
import 'package:depenses/layers/functional/Forecast/presentation/cubit/forecast_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';
import '../../forecast_seed.dart';

void main() {
  late TestDependencies dependencies;
  late ForecastCubit cubit;

  setUp(() {
    dependencies = TestDependencies(
      today: DateTime(2026, 10, 15),
      data: {
        'expenses': [forecastExpense('a', 150, '2026-10-03')],
        'recs': [forecastRecurrence('r1', 'Internet', 30, '2026-09-20')],
        'settings': {'income': 2000, 'payDay': 25, 'balance': 900, 'balanceDate': '2026-10-15'},
      },
    );
    cubit = dependencies.get<ForecastCubit>();
  });
  tearDown(() async {
    await cubit.close();
    await dependencies.dispose();
  });

  test('loading exposes the stats, the account projection and the remaining recurrences', () {
    final state = cubit.state;

    expect(state.status, ForecastStatus.ready);
    expect(state.stats?.spent, 150);
    expect(state.stats?.remainingRecurringTotal, 30);
    expect(state.remainingRecurrences, const [RecurrenceTally(name: 'Internet', count: 1)]);
    expect(state.account.hasBalance, isTrue);
    expect(state.account.payDatesLeftThisMonth, [DateTime(2026, 10, 25)]);
    expect(state.account.income, 2000);
  });

  test('a new expense refreshes the forecast', () async {
    await dependencies.get<ExpenseGateway>().add(
      Expense(id: 'b', name: 'b', amount: 50, date: DateTime(2026, 10, 14), categoryKey: 'ali'),
    );

    expect(cubit.state.stats?.spent, 200);
  });
}
