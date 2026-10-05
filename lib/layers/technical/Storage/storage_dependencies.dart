import 'package:get_it/get_it.dart';

import 'document_store.dart';
import 'id_generator.dart';
import 'ledger_changes.dart';
import 'open_document_store.dart';
import 'preferences_document_store.dart';
import 'timestamp_id_generator.dart';

Future<void> registerStorageDependencies(GetIt getIt) async {
  final store = await openDocumentStore();
  getIt
    ..registerSingleton<PreferencesDocumentStore>(store, dispose: (s) => s.close())
    ..registerSingleton<DocumentStore>(store)
    ..registerSingleton<LedgerChanges>(store)
    ..registerLazySingleton<IdGenerator>(TimestampIdGenerator.new);
}
