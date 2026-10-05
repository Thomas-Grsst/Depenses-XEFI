import 'package:get_it/get_it.dart';

import 'data/gateways/account_gateway_impl.dart';
import 'domain/gateways/account_gateway.dart';
import 'domain/use_cases/clear_balance_use_case.dart';
import 'domain/use_cases/get_account_settings_use_case.dart';
import 'domain/use_cases/get_account_summary_use_case.dart';
import 'domain/use_cases/get_balance_end_of_month_use_case.dart';
import 'domain/use_cases/get_balance_projection_use_case.dart';
import 'domain/use_cases/get_balance_use_case.dart';
import 'domain/use_cases/get_future_noted_use_case.dart';
import 'domain/use_cases/get_next_payday_use_case.dart';
import 'domain/use_cases/get_pay_dates_use_case.dart';
import 'domain/use_cases/revise_balance_use_case.dart';
import 'domain/use_cases/save_income_use_case.dart';
import 'domain/use_cases/set_balance_use_case.dart';
import 'presentation/cubit/account_cubit.dart';
import 'presentation/cubit/account_summary_cubit.dart';

void registerAccountDependencies(GetIt getIt) {
  getIt
    ..registerLazySingleton<AccountGateway>(() => AccountGatewayImpl(getIt()))
    ..registerLazySingleton(() => GetAccountSettingsUseCase(getIt()))
    ..registerLazySingleton(() => SaveIncomeUseCase(getIt()))
    ..registerLazySingleton(() => SetBalanceUseCase(getIt(), getIt(), getIt()))
    ..registerLazySingleton(() => ClearBalanceUseCase(getIt()))
    ..registerLazySingleton(() => GetBalanceProjectionUseCase(getIt(), getIt()))
    ..registerLazySingleton(() => GetBalanceUseCase(getIt(), getIt()))
    ..registerLazySingleton(() => GetNextPaydayUseCase(getIt(), getIt()))
    ..registerLazySingleton(() => GetPayDatesUseCase(getIt()))
    ..registerLazySingleton(() => GetFutureNotedUseCase(getIt(), getIt()))
    ..registerLazySingleton(() => GetBalanceEndOfMonthUseCase(getIt()))
    ..registerLazySingleton(() => GetAccountSummaryUseCase(getIt(), getIt(), getIt(), getIt(), getIt(), getIt()))
    ..registerLazySingleton(() => ReviseBalanceUseCase(getIt(), getIt(), getIt()))
    ..registerFactory(() => AccountCubit(getIt(), getIt(), getIt(), getIt(), getIt(), getIt(), getIt()))
    ..registerFactory(() => AccountSummaryCubit(getIt(), getIt(), getIt()));
}
