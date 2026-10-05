import 'package:depenses/layers/technical/Storage/secret_store.dart';
import 'package:depenses/layers/technical/Storage/preferences_secret_store.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'enable_banking_client.dart';
import 'enable_banking_config.dart';
import 'enable_banking_jwt.dart';

void registerOpenBankingDependencies(
  GetIt getIt, {
  EnableBankingConfig? config,
  http.Client? transport,
  SecretStore? secrets,
}) {
  getIt
    ..registerLazySingleton<EnableBankingConfig>(() => config ?? EnableBankingConfig.fromEnvironment())
    ..registerLazySingleton<http.Client>(() => transport ?? http.Client(), dispose: (client) => client.close())
    ..registerLazySingleton<SecretStore>(() => secrets ?? PreferencesSecretStore())
    ..registerLazySingleton(() => EnableBankingJwt(getIt(), DateTime.now))
    ..registerLazySingleton(() => EnableBankingClient(getIt(), getIt(), getIt()));
}
