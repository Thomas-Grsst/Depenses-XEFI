import 'package:get_it/get_it.dart';

import 'data/gateways/alert_setting_gateway_impl.dart';
import 'domain/gateways/alert_setting_gateway.dart';
import 'domain/use_cases/compare_months_use_case.dart';
import 'domain/use_cases/compute_month_stats_use_case.dart';
import 'domain/use_cases/count_remaining_recurrences_use_case.dart';
import 'domain/use_cases/detect_budget_alerts_use_case.dart';
import 'domain/use_cases/get_alerts_enabled_use_case.dart';
import 'domain/use_cases/get_category_moves_use_case.dart';
import 'domain/use_cases/get_comparable_months_use_case.dart';
import 'domain/use_cases/get_forecast_summary_use_case.dart';
import 'domain/use_cases/get_typical_month_use_case.dart';
import 'domain/use_cases/set_alerts_enabled_use_case.dart';
import 'presentation/cubit/compare_cubit.dart';
import 'presentation/cubit/forecast_cubit.dart';
import 'presentation/cubit/forecast_summary_cubit.dart';

void registerForecastDependencies(GetIt getIt) {
  getIt
    ..registerLazySingleton<AlertSettingGateway>(() => AlertSettingGatewayImpl(getIt()))
    ..registerLazySingleton(() => ComputeMonthStatsUseCase(getIt(), getIt(), getIt(), getIt(), getIt()))
    ..registerLazySingleton(() => GetTypicalMonthUseCase(getIt(), getIt(), getIt()))
    ..registerLazySingleton(() => DetectBudgetAlertsUseCase(getIt(), getIt()))
    ..registerLazySingleton(() => GetAlertsEnabledUseCase(getIt()))
    ..registerLazySingleton(() => SetAlertsEnabledUseCase(getIt()))
    ..registerLazySingleton(() => GetCategoryMovesUseCase(getIt()))
    ..registerLazySingleton(() => const CountRemainingRecurrencesUseCase())
    ..registerLazySingleton(() => CompareMonthsUseCase(getIt(), getIt(), getIt()))
    ..registerLazySingleton(() => GetComparableMonthsUseCase(getIt(), getIt()))
    ..registerLazySingleton(() => GetForecastSummaryUseCase(getIt(), getIt(), getIt(), getIt()))
    ..registerFactory(() => ForecastCubit(getIt(), getIt(), getIt(), getIt()))
    ..registerFactory(() => ForecastSummaryCubit(getIt(), getIt(), getIt()))
    ..registerFactory(() => CompareCubit(getIt(), getIt(), getIt(), getIt()));
}
