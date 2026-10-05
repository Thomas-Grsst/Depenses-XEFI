import 'package:depenses/app/session/app_session_cubit.dart';
import 'package:depenses/layers/functional/BankSync/domain/use_cases/should_synchronize_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../layers/functional/BankSync/domain/use_cases/synchronize_fakes/bank_server_stub.dart';
import '../../layers/functional/BankSync/domain/use_cases/synchronize_fakes/bank_sync_harness.dart';
import '../../layers/functional/BankSync/domain/use_cases/synchronize_fakes/fake_bank_directory_gateway.dart';

void main() {
  late BankSyncHarness harness;
  late FakeBankDirectoryGateway directory;

  setUp(() {
    harness = BankSyncHarness();
    directory = FakeBankDirectoryGateway();
    harness.server.transactionsByAccount['acc-1'] = readTransactionFixture('october_transactions.json');
  });
  tearDown(() => harness.dispose());

  AppSessionCubit openSession() {
    final dependencies = harness.dependencies;
    return AppSessionCubit(
      dependencies.get(),
      dependencies.get(),
      ShouldSynchronizeUseCase(directory, harness.accounts, now: () => harness.now),
      harness.synchronize,
      dependencies.store,
    );
  }

  test('synchronises the bank when the session resumes', () async {
    final session = openSession();

    await session.resume();

    expect(harness.expenses, hasLength(4));
    await session.close();
  });

  test('does not call the bank when synchronisation is not due', () async {
    directory.isConfigured = false;
    final session = openSession();

    await session.resume();

    expect(harness.server.requestedWindows, isEmpty);
    await session.close();
  });

  test('keeps the session alive when the bank is unreachable', () async {
    harness.server.isDown = true;
    final session = openSession();

    await expectLater(session.resume(), completes);

    expect(harness.expenses, isEmpty);
    await session.close();
  });
}
