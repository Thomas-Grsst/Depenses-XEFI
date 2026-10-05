import 'package:depenses/layers/technical/Storage/preferences_secret_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  setUp(() => SharedPreferencesAsyncPlatform.instance = InMemorySharedPreferencesAsync.empty());

  test('a secret is written, read back and deleted under a prefixed key', () async {
    final store = PreferencesSecretStore();

    await store.write('bank_session_a', 'session-1');
    final stored = await SharedPreferencesAsync().getString('depenses_secret_bank_session_a');
    final read = await store.read('bank_session_a');
    await store.delete('bank_session_a');

    expect(stored, 'session-1');
    expect(read, 'session-1');
    expect(await store.read('bank_session_a'), isNull);
  });
}
