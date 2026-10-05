import 'package:bloc_test/bloc_test.dart';
import 'package:depenses/layers/functional/BankSync/domain/entities/linked_bank_account.dart';
import 'package:depenses/layers/functional/BankSync/domain/entities/sync_report.dart';
import 'package:depenses/layers/functional/BankSync/domain/use_cases/get_linked_accounts_use_case.dart';
import 'package:depenses/layers/functional/BankSync/domain/use_cases/is_bank_sync_available_use_case.dart';
import 'package:depenses/layers/functional/BankSync/domain/use_cases/unlink_bank_account_use_case.dart';
import 'package:depenses/layers/functional/BankSync/presentation/cubit/bank_sync_cubit.dart';
import 'package:depenses/layers/functional/BankSync/presentation/cubit/bank_sync_failure.dart';
import 'package:depenses/layers/functional/BankSync/presentation/cubit/bank_sync_state.dart';
import 'package:depenses/layers/technical/OpenBanking/enable_banking_errors.dart';
import 'package:depenses/layers/technical/Storage/ledger_section.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/fixed_clock.dart';
import '../../../../../support/in_memory_document_store.dart';
import '../../support/bank_link_fakes.dart';

void main() {
  late FakeBankDirectoryGateway directory;
  late FakeLinkedAccountGateway accounts;
  late FakeBankAuthorizationGateway authorization;
  late FakeSynchronizeBankAccounts synchronize;
  late InMemoryDocumentStore changes;

  setUp(() {
    directory = FakeBankDirectoryGateway();
    accounts = FakeLinkedAccountGateway([linkedAccount()]);
    authorization = FakeBankAuthorizationGateway();
    synchronize = FakeSynchronizeBankAccounts();
    changes = InMemoryDocumentStore();
  });
  tearDown(() => changes.dispose());

  BankSyncCubit build() => BankSyncCubit(
    IsBankSyncAvailableUseCase(directory),
    GetLinkedAccountsUseCase(accounts, FixedClock(DateTime(2026, 10, 5))),
    UnlinkBankAccountUseCase(authorization, accounts),
    synchronize,
    changes,
  );

  test('loading exposes availability and the linked accounts with their status', () {
    accounts.accounts.add(linkedAccount(uid: 'old', validUntil: DateTime(2026, 9, 1)));
    final cubit = build();
    addTearDown(cubit.close);

    expect(cubit.state.isAvailable, isTrue);
    expect(cubit.state.accounts.map((overview) => overview.status), [
      LinkedAccountStatus.linked,
      LinkedAccountStatus.expired,
    ]);
  });

  test('an unconfigured Enable Banking hides the feature', () {
    directory.isConfigured = false;
    final cubit = build();
    addTearDown(cubit.close);

    expect(cubit.state.isAvailable, isFalse);
  });

  test('a ledger change reloads the accounts', () async {
    final cubit = build();
    addTearDown(cubit.close);

    accounts.accounts.clear();
    await changes.write(LedgerSection.bankAccounts, const []);

    expect(cubit.state.hasAccounts, isFalse);
  });

  blocTest<BankSyncCubit, BankSyncState>(
    'synchronizing exposes the report and the refreshed accounts',
    setUp: () {
      synchronize.report = const SyncReport(created: 3, matched: 1);
      synchronize.onCall = () => accounts.accounts[0] = linkedAccount(isRevoked: true);
    },
    build: build,
    act: (cubit) => cubit.synchronize(),
    expect: () => [
      isA<BankSyncState>().having((s) => s.status, 'status', BankSyncStatus.synchronizing),
      isA<BankSyncState>()
          .having((s) => s.status, 'status', BankSyncStatus.ready)
          .having((s) => s.report, 'report', const SyncReport(created: 3, matched: 1))
          .having((s) => s.accounts.single.isExpired, 'expired', isTrue),
    ],
  );

  blocTest<BankSyncCubit, BankSyncState>(
    'an unreachable bank becomes a friendly failure',
    setUp: () => synchronize.error = const BankUnavailableException('timeout'),
    build: build,
    act: (cubit) => cubit.synchronize(),
    skip: 1,
    expect: () => [
      isA<BankSyncState>()
          .having((s) => s.failure, 'failure', BankSyncFailure.unavailable)
          .having((s) => s.report, 'report', isNull)
          .having((s) => s.isBusy, 'busy', isFalse),
    ],
  );

  test('failures map to the matching notice', () {
    expect(BankSyncFailure.of(const BankAccessExpiredException('401')), BankSyncFailure.expired);
    expect(BankSyncFailure.of(const BankRateLimitedException('429')), BankSyncFailure.unavailable);
    expect(BankSyncFailure.of(const BankResponseFormatException('json')), BankSyncFailure.unavailable);
    expect(BankSyncFailure.of(const BankSyncNotConfiguredException()), BankSyncFailure.notConfigured);
  });

  test('a second tap while synchronizing is ignored', () async {
    final cubit = build();
    addTearDown(cubit.close);

    await Future.wait([cubit.synchronize(), cubit.synchronize()]);

    expect(synchronize.calls, 1);
  });

  blocTest<BankSyncCubit, BankSyncState>(
    'unlinking revokes the access and removes the account',
    build: build,
    act: (cubit) => cubit.unlink(accounts.all().single),
    verify: (cubit) {
      expect(authorization.revoked, hasLength(1));
      expect(cubit.state.hasAccounts, isFalse);
      expect(cubit.state.status, BankSyncStatus.ready);
    },
  );

  blocTest<BankSyncCubit, BankSyncState>(
    'unlinking while offline keeps the account and explains why',
    setUp: () => authorization.error = const BankUnavailableException('offline'),
    build: build,
    act: (cubit) => cubit.unlink(accounts.all().single),
    verify: (cubit) {
      expect(cubit.state.hasAccounts, isTrue);
      expect(cubit.state.failure, BankSyncFailure.unavailable);
    },
  );
}
