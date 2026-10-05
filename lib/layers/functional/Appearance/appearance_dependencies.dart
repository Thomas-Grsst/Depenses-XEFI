import 'package:get_it/get_it.dart';

import 'data/gateways/appearance_gateway_impl.dart';
import 'domain/gateways/appearance_gateway.dart';
import 'domain/use_cases/choose_visual_style_use_case.dart';
import 'domain/use_cases/get_appearance_use_case.dart';
import 'domain/use_cases/save_appearance_use_case.dart';
import 'presentation/cubit/appearance_cubit.dart';

void registerAppearanceDependencies(GetIt getIt) {
  getIt
    ..registerLazySingleton<AppearanceGateway>(() => AppearanceGatewayImpl(getIt()))
    ..registerLazySingleton(() => GetAppearanceUseCase(getIt()))
    ..registerLazySingleton(() => SaveAppearanceUseCase(getIt()))
    ..registerLazySingleton(() => ChooseVisualStyleUseCase(getIt()))
    ..registerFactory(() => AppearanceCubit(getIt(), getIt()));
}
