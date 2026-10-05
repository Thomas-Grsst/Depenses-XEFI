import 'package:get_it/get_it.dart';

import 'data/gateways/detection_setting_gateway_impl.dart';
import 'data/gateways/recurrence_gateway_impl.dart';
import 'domain/gateways/detection_setting_gateway.dart';
import 'domain/gateways/recurrence_gateway.dart';
import 'domain/use_cases/accept_suggestion_use_case.dart';
import 'domain/use_cases/add_recurrence_use_case.dart';
import 'domain/use_cases/delete_recurrence_use_case.dart';
import 'domain/use_cases/detect_recurring_expenses_use_case.dart';
import 'domain/use_cases/get_detection_enabled_use_case.dart';
import 'domain/use_cases/get_fixed_monthly_total_use_case.dart';
import 'domain/use_cases/get_month_schedule_use_case.dart';
import 'domain/use_cases/get_next_occurrences_use_case.dart';
import 'domain/use_cases/get_recurrence_use_case.dart';
import 'domain/use_cases/get_recurrences_by_monthly_amount_use_case.dart';
import 'domain/use_cases/get_recurrences_use_case.dart';
import 'domain/use_cases/get_upcoming_occurrences_use_case.dart';
import 'domain/use_cases/ignore_suggestion_use_case.dart';
import 'domain/use_cases/materialize_due_recurrences_use_case.dart';
import 'domain/use_cases/set_detection_enabled_use_case.dart';
import 'domain/use_cases/update_recurrence_use_case.dart';
import 'presentation/cubit/recurrences_cubit.dart';

void registerRecurrencesDependencies(GetIt getIt) {
  getIt
    ..registerLazySingleton<RecurrenceGateway>(() => RecurrenceGatewayImpl(getIt()))
    ..registerLazySingleton<DetectionSettingGateway>(() => DetectionSettingGatewayImpl(getIt()))
    ..registerLazySingleton(() => MaterializeDueRecurrencesUseCase(getIt(), getIt(), getIt(), getIt()))
    ..registerLazySingleton(() => AddRecurrenceUseCase(getIt(), getIt(), getIt(), getIt()))
    ..registerLazySingleton(() => UpdateRecurrenceUseCase(getIt(), getIt()))
    ..registerLazySingleton(() => DeleteRecurrenceUseCase(getIt()))
    ..registerLazySingleton(() => GetRecurrencesUseCase(getIt()))
    ..registerLazySingleton(() => GetRecurrenceUseCase(getIt()))
    ..registerLazySingleton(() => GetUpcomingOccurrencesUseCase(getIt()))
    ..registerLazySingleton(() => GetNextOccurrencesUseCase(getIt(), getIt()))
    ..registerLazySingleton(() => GetFixedMonthlyTotalUseCase(getIt()))
    ..registerLazySingleton(() => DetectRecurringExpensesUseCase(getIt(), getIt(), getIt(), getIt()))
    ..registerLazySingleton(() => AcceptSuggestionUseCase(getIt(), getIt(), getIt(), getIt()))
    ..registerLazySingleton(() => IgnoreSuggestionUseCase(getIt()))
    ..registerLazySingleton(() => GetDetectionEnabledUseCase(getIt()))
    ..registerLazySingleton(() => SetDetectionEnabledUseCase(getIt()))
    ..registerLazySingleton(() => GetRecurrencesByMonthlyAmountUseCase(getIt()))
    ..registerLazySingleton(() => GetMonthScheduleUseCase(getIt(), getIt(), getIt()))
    ..registerFactory(
      () => RecurrencesCubit(getIt(), getIt(), getIt(), getIt(), getIt(), getIt(), getIt(), getIt(), getIt(), getIt()),
    );
}
