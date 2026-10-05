import 'package:depenses/layers/functional/Account/account_dependencies.dart';
import 'package:depenses/layers/functional/Appearance/appearance_dependencies.dart';
import 'package:depenses/layers/functional/BankSync/bank_sync_dependencies.dart';
import 'package:depenses/layers/functional/Budget/budget_dependencies.dart';
import 'package:depenses/layers/functional/Categories/categories_dependencies.dart';
import 'package:depenses/layers/functional/Expenses/expenses_dependencies.dart';
import 'package:depenses/layers/functional/Forecast/forecast_dependencies.dart';
import 'package:depenses/layers/functional/Profile/profile_dependencies.dart';
import 'package:depenses/layers/functional/Recurrences/recurrences_dependencies.dart';
import 'package:depenses/layers/functional/Savings/savings_dependencies.dart';
import 'package:depenses/layers/functional/Simulations/simulations_dependencies.dart';
import 'package:depenses/layers/technical/Calendar/clock.dart';
import 'package:depenses/layers/technical/OpenBanking/enable_banking_config.dart';
import 'package:depenses/layers/technical/OpenBanking/open_banking_dependencies.dart';
import 'package:depenses/layers/technical/Storage/document_store.dart';
import 'package:depenses/layers/technical/Storage/id_generator.dart';
import 'package:depenses/layers/technical/Storage/ledger_changes.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'fixed_clock.dart';
import 'in_memory_document_store.dart';
import 'in_memory_secret_store.dart';
import 'sequential_id_generator.dart';

class TestDependencies {
  TestDependencies({
    DateTime? today,
    Map<String, dynamic>? data,
    http.Client? bankTransport,
    EnableBankingConfig? bankConfig,
  }) : store = InMemoryDocumentStore(data),
       clock = FixedClock(today ?? DateTime(2026, 10, 15)),
       secrets = InMemorySecretStore(),
       getIt = GetIt.asNewInstance() {
    getIt
      ..registerSingleton<DocumentStore>(store)
      ..registerSingleton<LedgerChanges>(store)
      ..registerSingleton<Clock>(clock)
      ..registerSingleton<IdGenerator>(SequentialIdGenerator());
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
    registerOpenBankingDependencies(
      getIt,
      config: bankConfig ?? const EnableBankingConfig(applicationId: '', privateKeyPem: ''),
      transport: bankTransport ?? MockClient((_) async => http.Response('{}', 404)),
      secrets: secrets,
    );
    registerBankSyncDependencies(getIt);
  }

  final InMemoryDocumentStore store;
  final FixedClock clock;
  final InMemorySecretStore secrets;
  final GetIt getIt;

  T get<T extends Object>() => getIt<T>();

  Future<void> dispose() async {
    await getIt.reset();
    await store.dispose();
  }
}
