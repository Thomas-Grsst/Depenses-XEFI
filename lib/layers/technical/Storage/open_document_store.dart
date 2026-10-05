import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences/util/legacy_to_async_migration_util.dart';

import 'preferences_document_store.dart';

const _migrationCompletedKey = 'depenses_preferences_migrated';

Future<PreferencesDocumentStore> openDocumentStore() async {
  await migrateLegacySharedPreferencesToSharedPreferencesAsyncIfNecessary(
    legacySharedPreferencesInstance: await SharedPreferences.getInstance(),
    sharedPreferencesAsyncOptions: const SharedPreferencesOptions(),
    migrationCompletedKey: _migrationCompletedKey,
  );
  final preferences = await SharedPreferencesWithCache.create(cacheOptions: const SharedPreferencesWithCacheOptions());
  return PreferencesDocumentStore(preferences);
}
