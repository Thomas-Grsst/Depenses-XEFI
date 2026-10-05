import 'dart:io';

import 'package:depenses/layers/functional/BankSync/domain/entities/linked_bank_account.dart';
import 'package:depenses/layers/functional/BankSync/domain/gateways/bank_link_gateway.dart';
import 'package:depenses/layers/functional/BankSync/domain/use_cases/synchronize_bank_accounts_use_case.dart';
import 'package:depenses/layers/functional/Expenses/domain/entities/expense.dart';
import 'package:depenses/layers/functional/Expenses/domain/gateways/expense_gateway.dart';
import 'package:depenses/layers/technical/OpenBanking/enable_banking_config.dart';

import '../../../../../../support/test_dependencies.dart';
import 'bank_server_stub.dart';
import 'fake_linked_account_gateway.dart';

const _privateKey = 'test/layers/technical/OpenBanking/fixtures/test_private_key.pem';

LinkedBankAccount linkedAccount(String uid, {DateTime? lastSyncedAt, bool isRevoked = false, DateTime? validUntil}) =>
    LinkedBankAccount(
      uid: uid,
      bankName: 'Banque de Test',
      country: 'FR',
      label: 'Compte $uid',
      accessValidUntil: validUntil ?? DateTime(2027, 1, 13),
      lastSyncedAt: lastSyncedAt,
      isRevoked: isRevoked,
    );

class BankSyncHarness {
  BankSyncHarness({List<LinkedBankAccount>? accounts})
    : server = BankServerStub(),
      accounts = FakeLinkedAccountGateway(accounts ?? [linkedAccount('acc-1')]) {
    dependencies = TestDependencies(
      today: DateTime(2026, 10, 15),
      bankTransport: server.client,
      bankConfig: EnableBankingConfig(applicationId: 'app-123', privateKeyPem: File(_privateKey).readAsStringSync()),
    );
    synchronize = SynchronizeBankAccountsUseCase(
      this.accounts,
      dependencies.get(),
      dependencies.get(),
      dependencies.get(),
      dependencies.get(),
      dependencies.clock,
      now: () => now,
    );
  }

  final BankServerStub server;
  final FakeLinkedAccountGateway accounts;
  late final TestDependencies dependencies;
  late final SynchronizeBankAccountsUseCase synchronize;
  DateTime now = DateTime(2026, 10, 15, 9);

  List<Expense> get expenses => dependencies.get<ExpenseGateway>().all();

  BankLinkGateway get links => dependencies.get<BankLinkGateway>();

  Future<void> dispose() => dependencies.dispose();
}
