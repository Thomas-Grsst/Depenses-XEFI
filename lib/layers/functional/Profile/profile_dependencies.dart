import 'package:get_it/get_it.dart';

import 'data/gateways/profile_gateway_impl.dart';
import 'domain/gateways/profile_gateway.dart';
import 'domain/use_cases/export_expenses_csv_use_case.dart';
import 'domain/use_cases/get_profile_name_use_case.dart';
import 'domain/use_cases/get_profile_overview_use_case.dart';
import 'domain/use_cases/is_onboarded_use_case.dart';
import 'domain/use_cases/reset_all_data_use_case.dart';
import 'domain/use_cases/save_profile_details_use_case.dart';
import 'domain/use_cases/save_profile_name_use_case.dart';
import 'presentation/cubit/profile_cubit.dart';

void registerProfileDependencies(GetIt getIt) {
  getIt
    ..registerLazySingleton<ProfileGateway>(() => ProfileGatewayImpl(getIt()))
    ..registerLazySingleton(() => GetProfileNameUseCase(getIt()))
    ..registerLazySingleton(() => SaveProfileNameUseCase(getIt()))
    ..registerLazySingleton(() => IsOnboardedUseCase(getIt()))
    ..registerLazySingleton(() => ExportExpensesCsvUseCase(getIt(), getIt()))
    ..registerLazySingleton(
      () => ResetAllDataUseCase(
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
      ),
    )
    ..registerLazySingleton(
      () => GetProfileOverviewUseCase(
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
      ),
    )
    ..registerLazySingleton(() => SaveProfileDetailsUseCase(getIt(), getIt(), getIt(), getIt(), getIt(), getIt()))
    ..registerFactory(
      () => ProfileCubit(getIt(), getIt(), getIt(), getIt(), getIt(), getIt(), getIt(), getIt(), getIt(), getIt()),
    );
}
