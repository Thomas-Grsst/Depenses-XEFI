import 'package:depenses/layers/functional/Account/domain/use_cases/get_account_settings_use_case.dart';
import 'package:depenses/layers/functional/Categories/domain/use_cases/get_category_use_case.dart';
import 'package:depenses/layers/functional/Forecast/domain/use_cases/compute_month_stats_use_case.dart';
import 'package:depenses/layers/functional/Forecast/domain/use_cases/get_typical_month_use_case.dart';
import 'package:depenses/layers/functional/Recurrences/domain/use_cases/get_fixed_monthly_total_use_case.dart';
import 'package:depenses/layers/functional/Savings/domain/use_cases/get_goals_use_case.dart';

import '../entities/envelope_baseline.dart';
import '../entities/simulation_baseline.dart';

class GetSimulationBaselineUseCase {
  GetSimulationBaselineUseCase(
    this._fixedMonthly,
    this._account,
    this._stats,
    this._category,
    this._typicalMonth,
    this._goals,
  );

  final GetFixedMonthlyTotalUseCase _fixedMonthly;
  final GetAccountSettingsUseCase _account;
  final ComputeMonthStatsUseCase _stats;
  final GetCategoryUseCase _category;
  final GetTypicalMonthUseCase _typicalMonth;
  final GetGoalsUseCase _goals;

  SimulationBaseline call() {
    final stats = _stats();
    final goals = _goals();
    return SimulationBaseline(
      today: stats.today,
      fixedMonthly: _fixedMonthly(),
      income: _account().income,
      envelopes: {
        for (final entry in stats.perCategory.entries)
          entry.key: EnvelopeBaseline(
            categoryKey: entry.key,
            categoryName: _category(entry.key).name,
            budget: entry.value.budget,
            projected: entry.value.projected,
          ),
      },
      typicalMonth: _typicalMonth(),
      goal: goals.isEmpty ? null : goals.first,
    );
  }
}
