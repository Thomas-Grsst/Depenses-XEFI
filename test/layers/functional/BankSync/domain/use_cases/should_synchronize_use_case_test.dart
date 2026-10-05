import 'package:depenses/layers/functional/BankSync/domain/use_cases/should_synchronize_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import 'synchronize_fakes/bank_sync_harness.dart';
import 'synchronize_fakes/fake_bank_directory_gateway.dart';
import 'synchronize_fakes/fake_linked_account_gateway.dart';

void main() {
  final now = DateTime(2026, 10, 15, 9);
  late FakeBankDirectoryGateway directory;
  late FakeLinkedAccountGateway accounts;
  late ShouldSynchronizeUseCase shouldSynchronize;

  setUp(() {
    directory = FakeBankDirectoryGateway();
    accounts = FakeLinkedAccountGateway();
    shouldSynchronize = ShouldSynchronizeUseCase(directory, accounts, now: () => now);
  });

  test('synchronises an account that was never synchronised', () {
    accounts.accounts.add(linkedAccount('acc-1'));

    expect(shouldSynchronize(), isTrue);
  });

  test('waits one hour after the last synchronisation of every account', () {
    accounts.accounts
      ..add(linkedAccount('acc-1', lastSyncedAt: DateTime(2026, 10, 15, 8, 30)))
      ..add(linkedAccount('acc-2', lastSyncedAt: DateTime(2026, 10, 15, 8, 59)));

    expect(shouldSynchronize(), isFalse);
  });

  test('synchronises again as soon as one account is older than one hour', () {
    accounts.accounts
      ..add(linkedAccount('acc-1', lastSyncedAt: DateTime(2026, 10, 15, 8, 30)))
      ..add(linkedAccount('acc-2', lastSyncedAt: DateTime(2026, 10, 15, 7, 59)));

    expect(shouldSynchronize(), isTrue);
  });

  test('does nothing without a configured client', () {
    directory.isConfigured = false;
    accounts.accounts.add(linkedAccount('acc-1'));

    expect(shouldSynchronize(), isFalse);
  });

  test('does nothing without an active account', () {
    expect(shouldSynchronize(), isFalse);

    accounts.accounts
      ..add(linkedAccount('acc-1', isRevoked: true))
      ..add(linkedAccount('acc-2', validUntil: DateTime(2026, 10, 15)));

    expect(shouldSynchronize(), isFalse);
  });
}
