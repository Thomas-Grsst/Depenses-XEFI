import 'package:get_it/get_it.dart';

import 'domain/use_cases/complete_onboarding_use_case.dart';
import 'presentation/cubit/onboarding_cubit.dart';

void registerOnboardingDependencies(GetIt getIt) {
  getIt
    ..registerLazySingleton(() => CompleteOnboardingUseCase(getIt(), getIt(), getIt()))
    ..registerFactory(() => OnboardingCubit(getIt(), getIt(), getIt(), getIt()));
}
