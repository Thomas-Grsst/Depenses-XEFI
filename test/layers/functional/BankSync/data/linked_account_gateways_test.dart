import 'dart:convert';
import 'dart:io';

import 'package:depenses/layers/functional/BankSync/domain/entities/bank.dart';
import 'package:depenses/layers/functional/BankSync/domain/gateways/authorization_state_gateway.dart';
import 'package:depenses/layers/functional/BankSync/domain/gateways/bank_authorization_gateway.dart';
import 'package:depenses/layers/functional/BankSync/domain/gateways/bank_directory_gateway.dart';
import 'package:depenses/layers/functional/BankSync/domain/gateways/linked_account_gateway.dart';
import 'package:depenses/layers/technical/OpenBanking/enable_banking_config.dart';
import 'package:depenses/layers/technical/Storage/ledger_section.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../../../../support/test_dependencies.dart';
import '../support/bank_link_fakes.dart';

const _fixtures = 'test/layers/technical/OpenBanking/fixtures';

String _fixture(String name) => File('$_fixtures/$name').readAsStringSync();

void main() {
  late List<http.Request> requests;
  late TestDependencies dependencies;
  late http.Response Function(http.Request request) reply;

  setUp(() {
    requests = [];
    reply = (_) => http.Response('{}', 200);
    dependencies = TestDependencies(
      today: DateTime(2026, 10, 5),
      bankConfig: EnableBankingConfig(
        applicationId: 'app-123',
        privateKeyPem: File('$_fixtures/test_private_key.pem').readAsStringSync(),
      ),
      bankTransport: MockClient((request) async {
        requests.add(request);
        return reply(request);
      }),
    );
  });
  tearDown(() => dependencies.dispose());

  test('linked accounts round-trip through the ledger JSON', () async {
    final accounts = dependencies.get<LinkedAccountGateway>();
    final account = linkedAccount(lastSyncedAt: DateTime(2026, 10, 4, 9, 30), lastBankBalance: 1180.5);

    await accounts.save(account);
    await accounts.save(linkedAccount(uid: 'account-2', isRevoked: true));
    await accounts.save(account.copyWith(lastBankBalance: 1200));

    final stored = dependencies.store.snapshot['bankAccounts'] as List;
    expect(stored.first, {
      'uid': 'account-1',
      'bank': 'Banque de Test',
      'country': 'FR',
      'label': 'Compte courant',
      'validUntil': '2027-01-03T00:00:00.000',
      'lastSync': '2026-10-04T09:30:00.000',
      'balance': 1200.0,
    });
    expect((stored.last as Map)['revoked'], isTrue);
    expect(accounts.all().map((known) => known.uid), ['account-1', 'account-2']);
    expect(accounts.all().last.isRevoked, isTrue);
  });

  test('removing an account forgets its session secret', () async {
    final accounts = dependencies.get<LinkedAccountGateway>();
    await accounts.save(linkedAccount());
    dependencies.secrets.values['bank_session_account-1'] = 'session-1';

    await accounts.remove('account-1');

    expect(accounts.all(), isEmpty);
    expect(dependencies.secrets.values, isEmpty);
  });

  test('the pending state survives in the bank settings without touching other keys', () async {
    final pending = dependencies.get<AuthorizationStateGateway>();
    await dependencies.store.write(LedgerSection.bankSettings, {'lastSync': '2026-10-04'});

    await pending.remember('state-1');
    expect(pending.pending(), 'state-1');

    await pending.clear();
    expect(pending.pending(), isNull);
    expect(dependencies.store.snapshot['bankSettings'], {'lastSync': '2026-10-04'});
  });

  test('the directory maps banks and their consent validity', () async {
    reply = (_) => http.Response.bytes(utf8.encode(_fixture('aspsps.json')), 200);
    final directory = dependencies.get<BankDirectoryGateway>();

    final banks = await directory.banks('FR');

    expect(directory.isAvailable(), isTrue);
    expect(banks.first.maximumConsentValidity, const Duration(days: 90));
    expect(banks.last.maximumConsentValidity, isNull);
  });

  test('completing stores the session secret for every linked account', () async {
    reply = (_) => http.Response(_fixture('session.json'), 200);

    final linked = await dependencies.get<BankAuthorizationGateway>().complete('code-1');

    final account = linked.single;
    expect(account.uid, 'account-1');
    expect(account.bankName, 'Banque de Test');
    expect(account.label, 'Compte courant');
    expect(account.accessValidUntil, DateTime.utc(2027, 1, 3, 12));
    expect(dependencies.secrets.values, {'bank_session_account-1': 'session-1'});
  });

  test('starting returns the bank authorization page', () async {
    reply = (_) => http.Response(_fixture('auth.json'), 200);

    final url = await dependencies.get<BankAuthorizationGateway>().start(
      const Bank(name: 'Banque de Test', country: 'FR'),
      state: 'state-1',
      redirectUrl: 'depenses://bank-callback',
      validUntil: DateTime.utc(2027, 1, 3),
    );

    expect(url.host, 'tilisy.enablebanking.com');
    expect((jsonDecode(requests.single.body) as Map)['redirect_url'], 'depenses://bank-callback');
  });

  test('revoking deletes the session unless another account still uses it', () async {
    final accounts = dependencies.get<LinkedAccountGateway>();
    final gateway = dependencies.get<BankAuthorizationGateway>();
    await accounts.save(linkedAccount());
    await accounts.save(linkedAccount(uid: 'account-2'));
    dependencies.secrets.values.addAll({'bank_session_account-1': 'session-1', 'bank_session_account-2': 'session-1'});

    await gateway.revoke(linkedAccount());
    expect(requests, isEmpty);

    await accounts.remove('account-1');
    await gateway.revoke(linkedAccount(uid: 'account-2'));
    expect(requests.single.method, 'DELETE');
    expect(requests.single.url.path, '/sessions/session-1');
  });

  test('revoking an already expired session is not an error', () async {
    reply = (_) => http.Response('{"error": "expired"}', 401);
    dependencies.secrets.values['bank_session_account-1'] = 'session-1';

    await dependencies.get<BankAuthorizationGateway>().revoke(linkedAccount());

    expect(requests, hasLength(1));
  });
}
