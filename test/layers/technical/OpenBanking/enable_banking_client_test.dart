import 'dart:convert';
import 'dart:io';

import 'package:depenses/layers/technical/OpenBanking/enable_banking_client.dart';
import 'package:depenses/layers/technical/OpenBanking/enable_banking_config.dart';
import 'package:depenses/layers/technical/OpenBanking/enable_banking_errors.dart';
import 'package:depenses/layers/technical/OpenBanking/enable_banking_jwt.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const _fixtures = 'test/layers/technical/OpenBanking/fixtures';

String _fixture(String name) => File('$_fixtures/$name').readAsStringSync();

void main() {
  final config = EnableBankingConfig(
    applicationId: 'app-123',
    privateKeyPem: File('$_fixtures/test_private_key.pem').readAsStringSync(),
  );
  late List<http.Request> requests;

  EnableBankingClient clientReplying(http.Response Function(http.Request request) reply) {
    requests = [];
    final transport = MockClient((request) async {
      requests.add(request);
      return reply(request);
    });
    return EnableBankingClient(config, transport, EnableBankingJwt(config, DateTime.now));
  }

  test('listing banks sends a signed request filtered by country', () async {
    final client = clientReplying((_) => http.Response.bytes(utf8.encode(_fixture('aspsps.json')), 200));

    final banks = await client.listBanks(country: 'FR');

    expect(banks.map((b) => b.name), ['Banque de Test', 'Crédit Exemple']);
    expect(requests.single.url.toString(), 'https://api.enablebanking.com/aspsps?country=FR');
    expect(requests.single.headers['Authorization'], startsWith('Bearer '));
  });

  test('starting an authorization posts the personal access request', () async {
    final client = clientReplying((_) => http.Response(_fixture('auth.json'), 200));

    final start = await client.startAuthorization(
      bankName: 'Banque de Test',
      country: 'FR',
      validUntil: DateTime.utc(2027, 1, 3),
      state: 'state-1',
      redirectUrl: 'http://localhost:8765/bank-callback',
    );

    final body = jsonDecode(requests.single.body) as Map<String, dynamic>;
    expect(requests.single.method, 'POST');
    expect(requests.single.url.path, '/auth');
    expect(body['aspsp'], {'name': 'Banque de Test', 'country': 'FR'});
    expect(body['psu_type'], 'personal');
    expect(body['state'], 'state-1');
    expect(start.url.host, 'tilisy.enablebanking.com');
  });

  test('creating a session returns the authorized accounts', () async {
    final client = clientReplying((_) => http.Response(_fixture('session.json'), 200));

    final session = await client.createSession(code: 'code-1');

    expect(jsonDecode(requests.single.body), {'code': 'code-1'});
    expect(session.sessionId, 'session-1');
    expect(session.accounts.single.uid, 'account-1');
    expect(session.validUntil, DateTime.utc(2027, 1, 3, 12));
  });

  test('transactions and balances are parsed with string or number amounts', () async {
    final client = clientReplying(
      (request) => http.Response(
        _fixture(request.url.path.endsWith('balances') ? 'balances.json' : 'transactions_page_2.json'),
        200,
      ),
    );

    final page = await client.transactions('account-1', from: DateTime(2026, 7, 7));
    final balances = await client.balances('account-1');

    expect(requests.first.url.queryParameters, {'date_from': '2026-07-07'});
    expect(page.transactions.single.amount, 19.99);
    expect(page.continuationKey, isNull);
    expect(balances.map((b) => b.type), ['CLBD', 'ITAV']);
    expect(balances.last.amount, 1180.5);
  });

  test('errors are mapped to named exceptions', () async {
    Future<void> callWith(int status) => clientReplying((_) => http.Response('{}', status)).balances('account-1');

    await expectLater(callWith(401), throwsA(isA<BankAccessExpiredException>()));
    await expectLater(callWith(403), throwsA(isA<BankAccessExpiredException>()));
    await expectLater(callWith(429), throwsA(isA<BankRateLimitedException>()));
    await expectLater(callWith(503), throwsA(isA<BankUnavailableException>()));
    await expectLater(
      clientReplying((_) => http.Response('not json', 200)).balances('account-1'),
      throwsA(isA<BankResponseFormatException>()),
    );
  });

  test('a missing configuration fails before any request', () async {
    final client = EnableBankingClient(
      const EnableBankingConfig(applicationId: '', privateKeyPem: ''),
      MockClient((_) async => fail('no request expected')),
      EnableBankingJwt(config, DateTime.now),
    );

    await expectLater(client.listBanks(country: 'FR'), throwsA(isA<BankSyncNotConfiguredException>()));
  });
}
