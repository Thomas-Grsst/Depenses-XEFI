import 'package:get_it/get_it.dart';

import 'cubit/home_lists_cubit.dart';

void registerHomeDependencies(GetIt getIt) {
  getIt.registerFactory(() => HomeListsCubit(getIt(), getIt(), getIt(), getIt(), getIt(), getIt(), getIt(), getIt()));
}
