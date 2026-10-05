import 'dart:io';

import 'package:depenses/layers/functional/BankSync/data/gateways/bank_data_gateway_impl.dart';
import 'package:depenses/layers/functional/BankSync/domain/entities/linked_bank_account.dart';
import 'package:depenses/layers/technical/OpenBanking/dto/balance_dto.dart';
import 'package:depenses/layers/technical/OpenBanking/enable_banking_client.dart';
import 'package:depenses/layers/technical/OpenBanking/enable_banking_config.dart';
import 'package:depenses/layers/technical/OpenBanking/enable_banking_jwt.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const _fixtures = 'test/layers/technical/OpenBanking/fixtures';

void main() {
  final config = EnableBankingConfig(
    applicationId: 'app-123',
    privateKeyPem: File('$_fixtures/test_private_key.pem').readAsStringSync(),
  );
  final account = LinkedBankAccount(
    uid: 'acc-1',
    bankName: 'Banque de Test',
    country: 'FR',
    label: 'Compte courant',
    accessValidUntil: DateTime(2027),
  );
  late List<Uri> requested;

  BankDataGatewayImpl gatewayReplying(String Function(Uri url) fixture) {
    requested = [];
    final transport = MockClient((request) async {
      requested.add(request.url);
      return http.Response.bytes(File('$_fixtures/${fixture(request.url)}').readAsBytesSync(), 200);
    });
    return BankDataGatewayImpl(EnableBankingClient(config, transport, EnableBankingJwt(config, DateTime.now)));
  }

  test('follows the continuation key until the last page and maps every transaction', () async {
    final gateway = gatewayReplying(
      (url) =>
          url.queryParameters['continuation_key'] == 'page-2' ? 'transactions_page_2.json' : 'transactions_page_1.json',
    );

    final transactions = await gateway.transactions(account, DateTime(2026, 7, 17));

    expect(transactions.map((t) => t.id), ['tx-1', 'tx-2', 'tx-3']);
    expect(requested, hasLength(2));
    expect(requested.first.path, '/accounts/acc-1/transactions');
    expect(requested.first.queryParameters['date_from'], '2026-07-17');
    expect(transactions.last.isPending, isTrue);
  });

  test('stops when the bank repeats a continuation key', () async {
    final gateway = gatewayReplying((_) => 'transactions_page_1.json');

    final transactions = await gateway.transactions(account, DateTime(2026, 7, 17));

    expect(requested, hasLength(2));
    expect(transactions, hasLength(4));
  });

  test('reads the interim available balance before the closing one', () async {
    final gateway = gatewayReplying((_) => 'balances.json');

    expect(await gateway.balance(account), 1180.50);
    expect(requested.single.path, '/accounts/acc-1/balances');
  });

  test('prefers ITAV, then CLAV, ITBD and CLBD, then any balance', () {
    BalanceDto balance(String type, double amount) => BalanceDto(type: type, amount: amount, currency: 'EUR');

    expect(BankDataGatewayImpl.preferredBalance([balance('CLBD', 1), balance('ITBD', 2), balance('CLAV', 3)]), 3);
    expect(BankDataGatewayImpl.preferredBalance([balance('CLBD', 1), balance('ITBD', 2)]), 2);
    expect(BankDataGatewayImpl.preferredBalance([balance('XPCD', 5), balance('CLBD', 1)]), 1);
    expect(BankDataGatewayImpl.preferredBalance([balance('XPCD', 5)]), 5);
    expect(BankDataGatewayImpl.preferredBalance(const []), isNull);
  });
}
