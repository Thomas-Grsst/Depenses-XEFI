import 'package:get_it/get_it.dart';

import 'data/gateways/goal_gateway_impl.dart';
import 'data/gateways/round_up_usage_gateway_impl.dart';
import 'domain/gateways/goal_gateway.dart';
import 'domain/gateways/round_up_usage_gateway.dart';
import 'domain/use_cases/add_goal_use_case.dart';
import 'domain/use_cases/delete_goal_use_case.dart';
import 'domain/use_cases/get_goals_use_case.dart';
import 'domain/use_cases/get_round_up_summary_use_case.dart';
import 'domain/use_cases/get_rounded_expenses_use_case.dart';
import 'domain/use_cases/move_round_up_to_goal_use_case.dart';
import 'domain/use_cases/save_goal_use_case.dart';
import 'domain/use_cases/update_goal_use_case.dart';
import 'presentation/cubit/savings_cubit.dart';
import 'presentation/cubit/savings_goals_cubit.dart';
import 'presentation/cubit/savings_summary_cubit.dart';

void registerSavingsDependencies(GetIt getIt) {
  getIt
    ..registerLazySingleton<GoalGateway>(() => GoalGatewayImpl(getIt()))
    ..registerLazySingleton<RoundUpUsageGateway>(() => RoundUpUsageGatewayImpl(getIt()))
    ..registerLazySingleton(() => GetGoalsUseCase(getIt()))
    ..registerLazySingleton(() => AddGoalUseCase(getIt(), getIt()))
    ..registerLazySingleton(() => UpdateGoalUseCase(getIt()))
    ..registerLazySingleton(() => DeleteGoalUseCase(getIt()))
    ..registerLazySingleton(() => SaveGoalUseCase(getIt(), getIt()))
    ..registerLazySingleton(() => GetRoundUpSummaryUseCase(getIt(), getIt()))
    ..registerLazySingleton(() => GetRoundedExpensesUseCase(getIt()))
    ..registerLazySingleton(() => MoveRoundUpToGoalUseCase(getIt(), getIt(), getIt(), getIt()))
    ..registerFactory(
      () => SavingsCubit(getIt(), getIt(), getIt(), getIt(), getIt(), getIt(), getIt(), getIt(), getIt(), getIt()),
    )
    ..registerFactory(() => SavingsGoalsCubit(getIt(), getIt(), getIt(), getIt(), getIt()))
    ..registerFactory(() => SavingsSummaryCubit(getIt(), getIt(), getIt(), getIt(), getIt()));
}
