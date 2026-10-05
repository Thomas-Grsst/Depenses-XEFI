import 'package:bloc_test/bloc_test.dart';
import 'package:depenses/layers/functional/BankSync/domain/use_cases/complete_bank_authorization_use_case.dart';
import 'package:depenses/layers/functional/BankSync/presentation/cubit/bank_callback_cubit.dart';
import 'package:depenses/layers/functional/BankSync/presentation/cubit/bank_callback_state.dart';
import 'package:depenses/layers/functional/BankSync/presentation/cubit/bank_sync_failure.dart';
import 'package:depenses/layers/technical/OpenBanking/enable_banking_errors.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/bank_link_fakes.dart';

void main() {
  late FakeBankAuthorizationGateway authorization;
  late FakeAuthorizationStateGateway pendingState;
  late FakeLinkedAccountGateway accounts;

  setUp(() {
    authorization = FakeBankAuthorizationGateway();
    pendingState = FakeAuthorizationStateGateway('state-1');
    accounts = FakeLinkedAccountGateway();
  });

  BankCallbackCubit build() =>
      BankCallbackCubit(CompleteBankAuthorizationUseCase(authorization, pendingState, accounts));

  blocTest<BankCallbackCubit, BankCallbackState>(
    'a valid redirect links the accounts',
    build: build,
    act: (cubit) => cubit.complete(Uri.parse('http://localhost:8765/bank-callback?code=code-1&state=state-1')),
    expect: () => [
      BankCallbackState(status: BankCallbackStatus.linked, accounts: [linkedAccount()]),
    ],
    verify: (_) => expect(accounts.all(), [linkedAccount()]),
  );

  blocTest<BankCallbackCubit, BankCallbackState>(
    'a web redirect carried in the hash route is understood',
    build: build,
    act: (cubit) => cubit.complete(Uri.parse('http://localhost:8080/#/bank-callback?code=code-1&state=state-1')),
    expect: () => [
      BankCallbackState(status: BankCallbackStatus.linked, accounts: [linkedAccount()]),
    ],
  );

  blocTest<BankCallbackCubit, BankCallbackState>(
    'a refusal at the bank is a cancellation',
    build: build,
    act: (cubit) => cubit.complete(Uri.parse('depenses://bank-callback?error=access_denied&state=state-1')),
    expect: () => [const BankCallbackState(status: BankCallbackStatus.cancelled)],
    verify: (_) => expect(accounts.all(), isEmpty),
  );

  blocTest<BankCallbackCubit, BankCallbackState>(
    'a state that does not match is rejected',
    build: build,
    act: (cubit) => cubit.complete(Uri.parse('depenses://bank-callback?code=code-1&state=forged')),
    expect: () => [const BankCallbackState(status: BankCallbackStatus.rejected)],
    verify: (_) => expect(authorization.completedCodes, isEmpty),
  );

  blocTest<BankCallbackCubit, BankCallbackState>(
    'an unreachable bank is a failure',
    setUp: () => authorization.error = const BankUnavailableException('offline'),
    build: build,
    act: (cubit) => cubit.complete(Uri.parse('depenses://bank-callback?code=code-1&state=state-1')),
    expect: () => [const BankCallbackState(status: BankCallbackStatus.failed, failure: BankSyncFailure.unavailable)],
  );

  blocTest<BankCallbackCubit, BankCallbackState>(
    'the same redirect is only completed once',
    build: build,
    act: (cubit) async {
      final callback = Uri.parse('depenses://bank-callback?code=code-1&state=state-1');
      await cubit.complete(callback);
      await cubit.complete(callback);
    },
    verify: (_) => expect(authorization.completedCodes, ['code-1']),
  );
}
