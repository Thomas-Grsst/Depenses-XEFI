import 'package:bloc_test/bloc_test.dart';
import 'package:depenses/layers/functional/BankSync/domain/entities/bank.dart';
import 'package:depenses/layers/functional/BankSync/domain/use_cases/get_banks_use_case.dart';
import 'package:depenses/layers/functional/BankSync/domain/use_cases/search_banks_use_case.dart';
import 'package:depenses/layers/functional/BankSync/domain/use_cases/start_bank_authorization_use_case.dart';
import 'package:depenses/layers/functional/BankSync/presentation/cubit/bank_picker_cubit.dart';
import 'package:depenses/layers/functional/BankSync/presentation/cubit/bank_picker_state.dart';
import 'package:depenses/layers/functional/BankSync/presentation/cubit/bank_sync_failure.dart';
import 'package:depenses/layers/technical/OpenBanking/callback/authorization_browser.dart';
import 'package:depenses/layers/technical/OpenBanking/enable_banking_errors.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/fixed_clock.dart';
import '../../support/bank_link_fakes.dart';

const _test = Bank(name: 'Banque de Test', country: 'FR');
const _credit = Bank(name: 'Crédit Exemple', country: 'FR');

void main() {
  late FakeBankDirectoryGateway directory;
  late FakeBankAuthorizationGateway authorization;
  late FakeAuthorizationStateGateway pendingState;
  late FakeCallbackListener listener;

  setUp(() {
    directory = FakeBankDirectoryGateway(knownBanks: const [_credit, _test]);
    authorization = FakeBankAuthorizationGateway();
    pendingState = FakeAuthorizationStateGateway();
    listener = FakeCallbackListener();
  });

  BankPickerCubit build() => BankPickerCubit(
    GetBanksUseCase(directory),
    const SearchBanksUseCase(),
    StartBankAuthorizationUseCase(
      authorization,
      pendingState,
      FixedStateGenerator(),
      FixedClock(DateTime(2026, 10, 5)),
    ),
    listener,
  );

  blocTest<BankPickerCubit, BankPickerState>(
    'loading lists the banks filtered by the initial query',
    build: build,
    act: (cubit) => cubit.load(query: 'crédit'),
    expect: () => [
      const BankPickerState(query: 'crédit'),
      const BankPickerState(
        status: BankPickerStatus.ready,
        banks: [_test, _credit],
        visibleBanks: [_credit],
        query: 'crédit',
      ),
    ],
  );

  blocTest<BankPickerCubit, BankPickerState>(
    'searching narrows the visible banks',
    build: build,
    act: (cubit) async {
      await cubit.load();
      cubit.search('test');
    },
    verify: (cubit) => expect(cubit.state.visibleBanks, [_test]),
  );

  blocTest<BankPickerCubit, BankPickerState>(
    'an unreachable directory can be retried',
    setUp: () => directory.error = const BankUnavailableException('offline'),
    build: build,
    act: (cubit) => cubit.load(),
    skip: 1,
    expect: () => [const BankPickerState(status: BankPickerStatus.failed, failure: BankSyncFailure.unavailable)],
  );

  blocTest<BankPickerCubit, BankPickerState>(
    'authorizing opens the bank page and waits for the redirect',
    build: build,
    act: (cubit) => cubit.authorize(_test, returnMessage: 'Reviens'),
    verify: (cubit) {
      expect(cubit.state.status, BankPickerStatus.awaitingCallback);
      expect(cubit.state.selectedBank, _test);
      expect(listener.opened, [authorization.authorizationUrl]);
      expect(listener.returnMessages, ['Reviens']);
      expect(authorization.started.single.redirectUrl, listener.redirectUrl);
      expect(pendingState.value, 'state-1');
    },
  );

  blocTest<BankPickerCubit, BankPickerState>(
    'a browser that cannot open is reported',
    setUp: () => listener.openError = AuthorizationBrowserException(Uri.parse('https://bank.example')),
    build: build,
    act: (cubit) => cubit.authorize(_test, returnMessage: 'Reviens'),
    verify: (cubit) {
      expect(cubit.state.status, BankPickerStatus.ready);
      expect(cubit.state.failure, BankSyncFailure.browserUnavailable);
    },
  );

  blocTest<BankPickerCubit, BankPickerState>(
    'a failed authorization start is reported',
    setUp: () => authorization.error = const BankRateLimitedException('429'),
    build: build,
    act: (cubit) => cubit.authorize(_test, returnMessage: 'Reviens'),
    verify: (cubit) => expect(cubit.state.failure, BankSyncFailure.unavailable),
  );

  blocTest<BankPickerCubit, BankPickerState>(
    'the redirect received by the platform listener is exposed',
    build: build,
    act: (cubit) => listener.deliver(Uri.parse('depenses://bank-callback?code=c&state=state-1')),
    expect: () => [BankPickerState(callback: Uri.parse('depenses://bank-callback?code=c&state=state-1'))],
  );

  blocTest<BankPickerCubit, BankPickerState>(
    'a pasted return address is accepted when it carries a code',
    build: build,
    act: (cubit) => cubit
      ..paste('nothing to see')
      ..paste('  http://localhost:8765/bank-callback?code=c&state=s  '),
    expect: () => [
      const BankPickerState(isPasteInvalid: true),
      BankPickerState(callback: Uri.parse('http://localhost:8765/bank-callback?code=c&state=s')),
    ],
  );

  test('closing the picker stops the platform listener', () async {
    await build().close();

    expect(listener.isClosed, isTrue);
  });
}
