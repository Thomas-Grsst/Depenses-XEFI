import 'package:depenses/layers/functional/Account/account_dependencies.dart';
import 'package:depenses/layers/functional/Appearance/appearance_dependencies.dart';
import 'package:depenses/layers/functional/BankSync/bank_sync_dependencies.dart';
import 'package:depenses/layers/functional/BankSync/domain/use_cases/dismiss_imported_expense_use_case.dart';
import 'package:depenses/layers/functional/Budget/budget_dependencies.dart';
import 'package:depenses/layers/functional/Categories/categories_dependencies.dart';
import 'package:depenses/layers/functional/Expenses/domain/gateways/expense_deletion_listener.dart';
import 'package:depenses/layers/functional/Expenses/expenses_dependencies.dart';
import 'package:depenses/layers/functional/Forecast/forecast_dependencies.dart';
import 'package:depenses/layers/functional/Onboarding/onboarding_dependencies.dart';
import 'package:depenses/layers/functional/Profile/profile_dependencies.dart';
import 'package:depenses/layers/functional/Recurrences/recurrences_dependencies.dart';
import 'package:depenses/layers/functional/Savings/savings_dependencies.dart';
import 'package:depenses/layers/functional/Simulations/simulations_dependencies.dart';
import 'package:depenses/layers/technical/Calendar/calendar_dependencies.dart';
import 'package:depenses/layers/technical/OpenBanking/open_banking_dependencies.dart';
import 'package:depenses/layers/technical/Storage/storage_dependencies.dart';
import 'package:get_it/get_it.dart';

import 'home/home_dependencies.dart';
import 'session/app_session_cubit.dart';
import 'shell/shell_tab_cubit.dart';

Future<void> registerAppDependencies(GetIt getIt) async {
  if (getIt.isRegistered<AppSessionCubit>()) return;
  await registerStorageDependencies(getIt);
  registerCalendarDependencies(getIt);
  registerOpenBankingDependencies(getIt);
  registerFunctionalDependencies(getIt);
  registerHomeDependencies(getIt);
  getIt
    ..registerLazySingleton<ExpenseDeletionListener>(() => getIt<DismissImportedExpenseUseCase>())
    ..registerFactory(() => AppSessionCubit(getIt(), getIt(), getIt(), getIt(), getIt()))
    ..registerFactory(ShellTabCubit.new);
}

void registerFunctionalDependencies(GetIt getIt) {
  registerCategoriesDependencies(getIt);
  registerExpensesDependencies(getIt);
  registerRecurrencesDependencies(getIt);
  registerBudgetDependencies(getIt);
  registerForecastDependencies(getIt);
  registerAccountDependencies(getIt);
  registerSavingsDependencies(getIt);
  registerSimulationsDependencies(getIt);
  registerProfileDependencies(getIt);
  registerAppearanceDependencies(getIt);
  registerOnboardingDependencies(getIt);
  registerBankSyncDependencies(getIt);
}
