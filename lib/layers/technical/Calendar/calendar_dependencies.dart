import 'package:get_it/get_it.dart';

import 'clock.dart';
import 'system_clock.dart';

void registerCalendarDependencies(GetIt getIt) {
  getIt.registerLazySingleton<Clock>(() => const SystemClock());
}
