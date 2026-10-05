import 'package:depenses/layers/functional/Forecast/domain/entities/budget_alert.dart';
import 'package:depenses/layers/functional/Forecast/domain/use_cases/set_alerts_enabled_use_case.dart';
import 'package:depenses/layers/functional/Forecast/presentation/cubit/forecast_summary_cubit.dart';
import 'package:depenses/layers/functional/Forecast/presentation/cubit/forecast_summary_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';
import '../../forecast_seed.dart';

void main() {
  late TestDependencies dependencies;
  late ForecastSummaryCubit cubit;

  setUp(() {
    dependencies = TestDependencies(
      today: DateTime(2026, 10, 15),
      data: {
        'expenses': [forecastExpense('a', 120, '2026-10-03'), forecastExpense('b', 40, '2026-09-03')],
        'envelopes': {'ali': 100},
      },
    );
    cubit = dependencies.get<ForecastSummaryCubit>();
  });
  tearDown(() async {
    await cubit.close();
    await dependencies.dispose();
  });

  test('loading exposes the summary and the categories by key', () {
    final state = cubit.state;

    expect(state.status, ForecastSummaryStatus.ready);
    expect(state.hasAlerts, isTrue);
    expect(state.summary?.alerts.single.kind, BudgetAlertKind.overspent);
    expect(state.summary?.largestMoves.single.categoryKey, 'ali');
    expect(state.categories['ali']?.name, 'Alimentation');
  });

  test('turning alerts off refreshes the summary', () async {
    await dependencies.get<SetAlertsEnabledUseCase>()(false);

    expect(cubit.state.hasAlerts, isFalse);
    expect(cubit.state.summary?.areAlertsEnabled, isFalse);
  });
}
