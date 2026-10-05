import 'dart:io';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:depenses/layers/technical/OpenBanking/enable_banking_config.dart';
import 'package:depenses/layers/technical/OpenBanking/enable_banking_jwt.dart';
import 'package:flutter_test/flutter_test.dart';

const _fixtures = 'test/layers/technical/OpenBanking/fixtures';

void main() {
  final privateKey = File('$_fixtures/test_private_key.pem').readAsStringSync();
  final publicKey = RSAPublicKey(File('$_fixtures/test_public_key.pem').readAsStringSync());
  final config = EnableBankingConfig(applicationId: 'app-123', privateKeyPem: privateKey);

  test('the token is signed in RS256 with the application id as key id and a one hour lifetime', () {
    final now = DateTime.utc(2026, 10, 5, 12);
    final token = EnableBankingJwt(config, () => now).current();

    final verified = JWT.verify(token, publicKey, checkExpiresIn: false);

    expect(verified.header, containsPair('kid', 'app-123'));
    expect(verified.header, containsPair('alg', 'RS256'));
    final payload = verified.payload as Map<String, dynamic>;
    final issuedAt = now.millisecondsSinceEpoch ~/ 1000;
    expect(payload['iss'], 'enablebanking.com');
    expect(payload['aud'], 'api.enablebanking.com');
    expect(payload['iat'], issuedAt);
    expect(payload['exp'], issuedAt + 3600);
  });

  test('the token is reused until five minutes before it expires', () {
    var now = DateTime.utc(2026, 10, 5, 12);
    final jwt = EnableBankingJwt(config, () => now);
    final first = jwt.current();

    now = now.add(const Duration(minutes: 54));
    final reused = jwt.current();
    now = now.add(const Duration(minutes: 2));
    final renewed = jwt.current();

    expect(reused, first);
    expect(renewed, isNot(first));
  });

  test('a configuration without credentials is not configured', () {
    expect(const EnableBankingConfig(applicationId: '', privateKeyPem: '').isConfigured, isFalse);
    expect(config.isConfigured, isTrue);
  });
}
