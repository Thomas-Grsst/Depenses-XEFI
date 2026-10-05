import 'dart:async';

import 'package:depenses/layers/functional/BankSync/domain/entities/bank.dart';
import 'package:depenses/layers/functional/BankSync/domain/entities/linked_bank_account.dart';
import 'package:depenses/layers/functional/BankSync/domain/entities/sync_report.dart';
import 'package:depenses/layers/functional/BankSync/domain/gateways/authorization_state_gateway.dart';
import 'package:depenses/layers/functional/BankSync/domain/gateways/bank_authorization_gateway.dart';
import 'package:depenses/layers/functional/BankSync/domain/gateways/bank_directory_gateway.dart';
import 'package:depenses/layers/functional/BankSync/domain/gateways/linked_account_gateway.dart';
import 'package:depenses/layers/functional/BankSync/domain/use_cases/synchronize_bank_accounts_use_case.dart';
import 'package:depenses/layers/technical/OpenBanking/authorization_callback_listener.dart';
import 'package:depenses/layers/technical/OpenBanking/authorization_state_generator.dart';

LinkedBankAccount linkedAccount({
  String uid = 'account-1',
  String bankName = 'Banque de Test',
  DateTime? validUntil,
  DateTime? lastSyncedAt,
  double? lastBankBalance,
  bool isRevoked = false,
}) => LinkedBankAccount(
  uid: uid,
  bankName: bankName,
  country: 'FR',
  label: 'Compte courant',
  accessValidUntil: validUntil ?? DateTime(2027, 1, 3),
  lastSyncedAt: lastSyncedAt,
  lastBankBalance: lastBankBalance,
  isRevoked: isRevoked,
);

class StartedAuthorization {
  const StartedAuthorization(this.bank, this.state, this.redirectUrl, this.validUntil);

  final Bank bank;
  final String state;
  final String redirectUrl;
  final DateTime validUntil;
}

class FakeBankAuthorizationGateway implements BankAuthorizationGateway {
  final List<StartedAuthorization> started = [];
  final List<String> completedCodes = [];
  final List<LinkedBankAccount> revoked = [];
  List<LinkedBankAccount> accountsToLink = [linkedAccount()];
  Uri authorizationUrl = Uri.parse('https://bank.example/authorize');
  Object? error;

  @override
  Future<Uri> start(Bank bank, {required String state, required String redirectUrl, required DateTime validUntil}) {
    started.add(StartedAuthorization(bank, state, redirectUrl, validUntil));
    return _answer(authorizationUrl);
  }

  @override
  Future<List<LinkedBankAccount>> complete(String code) {
    completedCodes.add(code);
    return _answer(accountsToLink);
  }

  @override
  Future<void> revoke(LinkedBankAccount account) {
    revoked.add(account);
    return _answer(null);
  }

  Future<T> _answer<T>(T value) async {
    final failure = error;
    if (failure != null) throw failure;
    return value;
  }
}

class FakeAuthorizationStateGateway implements AuthorizationStateGateway {
  FakeAuthorizationStateGateway([this.value]);

  String? value;

  @override
  String? pending() => value;

  @override
  Future<void> remember(String state) async => value = state;

  @override
  Future<void> clear() async => value = null;
}

class FakeLinkedAccountGateway implements LinkedAccountGateway {
  FakeLinkedAccountGateway([List<LinkedBankAccount> accounts = const []]) : accounts = [...accounts];

  final List<LinkedBankAccount> accounts;

  @override
  List<LinkedBankAccount> all() => List.unmodifiable(accounts);

  @override
  Future<void> save(LinkedBankAccount account) async {
    accounts.removeWhere((known) => known.uid == account.uid);
    accounts.add(account);
  }

  @override
  Future<void> remove(String uid) async => accounts.removeWhere((known) => known.uid == uid);
}

class FakeBankDirectoryGateway implements BankDirectoryGateway {
  FakeBankDirectoryGateway({this.isConfigured = true, this.knownBanks = const []});

  bool isConfigured;
  List<Bank> knownBanks;
  Object? error;
  final List<String> requestedCountries = [];

  @override
  bool isAvailable() => isConfigured;

  @override
  Future<List<Bank>> banks(String country) async {
    requestedCountries.add(country);
    final failure = error;
    if (failure != null) throw failure;
    return knownBanks;
  }
}

class FixedStateGenerator implements AuthorizationStateGenerator {
  FixedStateGenerator([this.state = 'state-1']);

  final String state;

  @override
  String next() => state;
}

class FakeCallbackListener implements AuthorizationCallbackListener {
  final StreamController<Uri> _callbacks = StreamController<Uri>.broadcast(sync: true);
  final List<Uri> opened = [];
  final List<String> returnMessages = [];
  Object? openError;
  bool isClosed = false;

  void deliver(Uri callback) => _callbacks.add(callback);

  @override
  String get redirectUrl => 'http://localhost:8765/bank-callback';

  @override
  Stream<Uri> get callbacks => _callbacks.stream;

  @override
  Future<void> open(Uri authorizationUrl, {required String returnMessage}) async {
    final failure = openError;
    if (failure != null) throw failure;
    opened.add(authorizationUrl);
    returnMessages.add(returnMessage);
  }

  @override
  Future<void> close() async {
    isClosed = true;
    await _callbacks.close();
  }
}

class FakeSynchronizeBankAccounts implements SynchronizeBankAccountsUseCase {
  FakeSynchronizeBankAccounts({this.report = const SyncReport(), this.onCall});

  SyncReport report;
  Object? error;
  void Function()? onCall;
  int calls = 0;

  @override
  Future<SyncReport> call() async {
    calls++;
    onCall?.call();
    final failure = error;
    if (failure != null) throw failure;
    return report;
  }
}
