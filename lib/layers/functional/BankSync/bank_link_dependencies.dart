import 'package:depenses/layers/technical/OpenBanking/authorization_callback_listener.dart';
import 'package:depenses/layers/technical/OpenBanking/authorization_state_generator.dart';
import 'package:depenses/layers/technical/OpenBanking/callback/platform_callback_listener.dart';
import 'package:depenses/layers/technical/OpenBanking/secure_authorization_state_generator.dart';
import 'package:get_it/get_it.dart';

import 'data/gateways/authorization_state_gateway_impl.dart';
import 'data/gateways/bank_authorization_gateway_impl.dart';
import 'data/gateways/bank_directory_gateway_impl.dart';
import 'data/gateways/linked_account_gateway_impl.dart';
import 'domain/gateways/authorization_state_gateway.dart';
import 'domain/gateways/bank_authorization_gateway.dart';
import 'domain/gateways/bank_directory_gateway.dart';
import 'domain/gateways/linked_account_gateway.dart';
import 'domain/use_cases/align_balance_on_bank_use_case.dart';
import 'domain/use_cases/complete_bank_authorization_use_case.dart';
import 'domain/use_cases/get_balance_gap_use_case.dart';
import 'domain/use_cases/get_banks_use_case.dart';
import 'domain/use_cases/get_linked_accounts_use_case.dart';
import 'domain/use_cases/is_bank_sync_available_use_case.dart';
import 'domain/use_cases/search_banks_use_case.dart';
import 'domain/use_cases/start_bank_authorization_use_case.dart';
import 'domain/use_cases/unlink_bank_account_use_case.dart';
import 'presentation/cubit/bank_balance_cubit.dart';
import 'presentation/cubit/bank_callback_cubit.dart';
import 'presentation/cubit/bank_picker_cubit.dart';
import 'presentation/cubit/bank_sync_cubit.dart';

void registerBankLinkDependencies(GetIt getIt) {
  getIt
    ..registerLazySingleton<AuthorizationStateGenerator>(SecureAuthorizationStateGenerator.new)
    ..registerFactory<AuthorizationCallbackListener>(createPlatformCallbackListener)
    ..registerLazySingleton<LinkedAccountGateway>(() => LinkedAccountGatewayImpl(getIt(), getIt()))
    ..registerLazySingleton<AuthorizationStateGateway>(() => AuthorizationStateGatewayImpl(getIt()))
    ..registerLazySingleton<BankDirectoryGateway>(() => BankDirectoryGatewayImpl(getIt()))
    ..registerLazySingleton<BankAuthorizationGateway>(
      () => BankAuthorizationGatewayImpl(getIt(), getIt(), getIt(), getIt()),
    )
    ..registerLazySingleton(() => IsBankSyncAvailableUseCase(getIt()))
    ..registerLazySingleton(() => GetBanksUseCase(getIt()))
    ..registerLazySingleton(SearchBanksUseCase.new)
    ..registerLazySingleton(() => StartBankAuthorizationUseCase(getIt(), getIt(), getIt(), getIt()))
    ..registerLazySingleton(() => CompleteBankAuthorizationUseCase(getIt(), getIt(), getIt()))
    ..registerLazySingleton(() => UnlinkBankAccountUseCase(getIt(), getIt()))
    ..registerLazySingleton(() => GetLinkedAccountsUseCase(getIt(), getIt()))
    ..registerLazySingleton(() => GetBalanceGapUseCase(getIt(), getIt(), getIt()))
    ..registerLazySingleton(() => AlignBalanceOnBankUseCase(getIt(), getIt()))
    ..registerFactory(() => BankSyncCubit(getIt(), getIt(), getIt(), getIt(), getIt()))
    ..registerFactory(() => BankPickerCubit(getIt(), getIt(), getIt(), getIt()))
    ..registerFactory(() => BankCallbackCubit(getIt()))
    ..registerFactory(() => BankBalanceCubit(getIt(), getIt(), getIt()));
}
