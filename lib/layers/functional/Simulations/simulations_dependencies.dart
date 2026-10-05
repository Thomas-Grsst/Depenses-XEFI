import 'package:get_it/get_it.dart';

import 'data/gateways/scenario_gateway_impl.dart';
import 'domain/gateways/scenario_gateway.dart';
import 'domain/use_cases/compare_scenarios_use_case.dart';
import 'domain/use_cases/compute_scenario_impact_use_case.dart';
import 'domain/use_cases/create_scenario_use_case.dart';
import 'domain/use_cases/delete_scenario_use_case.dart';
import 'domain/use_cases/describe_hypothesis_badges_use_case.dart';
import 'domain/use_cases/get_scenarios_use_case.dart';
import 'domain/use_cases/get_simulable_recurrences_use_case.dart';
import 'domain/use_cases/get_simulation_baseline_use_case.dart';
import 'domain/use_cases/hypothesize_new_charge_use_case.dart';
import 'domain/use_cases/hypothesize_recurrence_change_use_case.dart';
import 'domain/use_cases/save_scenario_use_case.dart';
import 'domain/use_cases/update_scenario_use_case.dart';
import 'presentation/cubit/simulation_cubit.dart';
import 'presentation/cubit/simulations_cubit.dart';

void registerSimulationsDependencies(GetIt getIt) {
  getIt
    ..registerLazySingleton<ScenarioGateway>(() => ScenarioGatewayImpl(getIt()))
    ..registerLazySingleton(() => GetScenariosUseCase(getIt()))
    ..registerLazySingleton(() => CreateScenarioUseCase(getIt(), getIt(), getIt()))
    ..registerLazySingleton(() => UpdateScenarioUseCase(getIt()))
    ..registerLazySingleton(() => DeleteScenarioUseCase(getIt()))
    ..registerLazySingleton(() => SaveScenarioUseCase(getIt()))
    ..registerLazySingleton(() => GetSimulationBaselineUseCase(getIt(), getIt(), getIt(), getIt(), getIt(), getIt()))
    ..registerLazySingleton(ComputeScenarioImpactUseCase.new)
    ..registerLazySingleton(CompareScenariosUseCase.new)
    ..registerLazySingleton(() => GetSimulableRecurrencesUseCase(getIt()))
    ..registerLazySingleton(HypothesizeRecurrenceChangeUseCase.new)
    ..registerLazySingleton(() => HypothesizeNewChargeUseCase(getIt()))
    ..registerLazySingleton(() => DescribeHypothesisBadgesUseCase(getIt(), getIt()))
    ..registerFactory(() => SimulationsCubit(getIt(), getIt(), getIt(), getIt(), getIt(), getIt()))
    ..registerFactory(
      () => SimulationCubit(getIt(), getIt(), getIt(), getIt(), getIt(), getIt(), getIt(), getIt(), getIt()),
    );
}
