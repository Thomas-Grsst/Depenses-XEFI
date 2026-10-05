import 'package:shared_preferences/shared_preferences.dart';

import 'secret_store.dart';

const _keyPrefix = 'depenses_secret_';

class PreferencesSecretStore implements SecretStore {
  PreferencesSecretStore([SharedPreferencesAsync? preferences])
    : _preferences = preferences ?? SharedPreferencesAsync();

  final SharedPreferencesAsync _preferences;

  @override
  Future<String?> read(String key) => _preferences.getString('$_keyPrefix$key');

  @override
  Future<void> write(String key, String value) => _preferences.setString('$_keyPrefix$key', value);

  @override
  Future<void> delete(String key) => _preferences.remove('$_keyPrefix$key');
}
