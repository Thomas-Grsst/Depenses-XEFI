import 'package:get_it/get_it.dart';

import 'domain/use_cases/should_synchronize_use_case.dart';
import 'domain/use_cases/synchronize_bank_accounts_use_case.dart';

void registerBankImportDependencies(GetIt getIt) {
  getIt
    ..registerLazySingleton(SynchronizeBankAccountsUseCase.new)
    ..registerLazySingleton(ShouldSynchronizeUseCase.new);
}
