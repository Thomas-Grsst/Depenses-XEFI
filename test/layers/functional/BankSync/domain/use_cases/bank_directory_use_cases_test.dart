import 'package:depenses/layers/functional/BankSync/domain/entities/bank.dart';
import 'package:depenses/layers/functional/BankSync/domain/entities/linked_bank_account.dart';
import 'package:depenses/layers/functional/BankSync/domain/use_cases/get_banks_use_case.dart';
import 'package:depenses/layers/functional/BankSync/domain/use_cases/get_linked_accounts_use_case.dart';
import 'package:depenses/layers/functional/BankSync/domain/use_cases/is_bank_sync_available_use_case.dart';
import 'package:depenses/layers/functional/BankSync/domain/use_cases/search_banks_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/fixed_clock.dart';
import '../../support/bank_link_fakes.dart';

const _banks = [
  Bank(name: 'Société Générale', country: 'FR'),
  Bank(name: 'BNP Paribas', country: 'FR'),
  Bank(name: 'Crédit Agricole', country: 'FR'),
];

void main() {
  test('banks are listed for France by default, sorted by name', () async {
    final directory = FakeBankDirectoryGateway(knownBanks: _banks);

    final banks = await GetBanksUseCase(directory)();

    expect(directory.requestedCountries, ['FR']);
    expect(banks.map((bank) => bank.name), ['BNP Paribas', 'Crédit Agricole', 'Société Générale']);
  });

  test('searching ignores case and accents', () {
    const search = SearchBanksUseCase();

    expect(search(_banks, 'credit').map((bank) => bank.name), ['Crédit Agricole']);
    expect(search(_banks, '  '), _banks);
    expect(search(_banks, 'revolut'), isEmpty);
  });

  test('availability follows the Enable Banking configuration', () {
    final directory = FakeBankDirectoryGateway(isConfigured: false);
    final isAvailable = IsBankSyncAvailableUseCase(directory);

    expect(isAvailable(), isFalse);
    directory.isConfigured = true;
    expect(isAvailable(), isTrue);
  });

  test('linked accounts expose their status for today', () {
    final accounts = FakeLinkedAccountGateway([
      linkedAccount(uid: 'valid', validUntil: DateTime(2027, 1, 3)),
      linkedAccount(uid: 'outdated', validUntil: DateTime(2026, 10, 1)),
      linkedAccount(uid: 'revoked', isRevoked: true),
    ]);

    final overviews = GetLinkedAccountsUseCase(accounts, FixedClock(DateTime(2026, 10, 5)))();

    expect(overviews.map((overview) => overview.status), [
      LinkedAccountStatus.linked,
      LinkedAccountStatus.expired,
      LinkedAccountStatus.expired,
    ]);
    expect(overviews.first.isExpired, isFalse);
  });
}
