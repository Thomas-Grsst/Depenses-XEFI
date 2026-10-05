import 'package:get_it/get_it.dart';

import 'data/gateways/bank_data_gateway_impl.dart';
import 'data/gateways/bank_link_gateway_impl.dart';
import 'domain/gateways/bank_data_gateway.dart';
import 'domain/gateways/bank_link_gateway.dart';
import 'domain/use_cases/dismiss_imported_expense_use_case.dart';
import 'domain/use_cases/reconcile_bank_transaction_use_case.dart';
import 'domain/use_cases/should_synchronize_use_case.dart';
import 'domain/use_cases/synchronize_bank_accounts_use_case.dart';

void registerBankImportDependencies(GetIt getIt) {
  getIt
    ..registerLazySingleton<BankDataGateway>(() => BankDataGatewayImpl(getIt()))
    ..registerLazySingleton<BankLinkGateway>(() => BankLinkGatewayImpl(getIt()))
    ..registerLazySingleton(() => ReconcileBankTransactionUseCase(getIt(), getIt()))
    ..registerLazySingleton(
      () => SynchronizeBankAccountsUseCase(getIt(), getIt(), getIt(), getIt(), getIt(), getIt(), getIt()),
    )
    ..registerLazySingleton(() => ShouldSynchronizeUseCase(getIt(), getIt()))
    ..registerLazySingleton(() => DismissImportedExpenseUseCase(getIt()));
}
