import 'package:depenses/layers/functional/BankSync/domain/entities/bank.dart';
import 'package:depenses/layers/functional/BankSync/domain/entities/bank_authorization_cancelled_exception.dart';
import 'package:depenses/layers/functional/BankSync/domain/entities/bank_authorization_rejected_exception.dart';
import 'package:depenses/layers/functional/BankSync/domain/use_cases/complete_bank_authorization_use_case.dart';
import 'package:depenses/layers/functional/BankSync/domain/use_cases/start_bank_authorization_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/fixed_clock.dart';
import '../../support/bank_link_fakes.dart';

void main() {
  late FakeBankAuthorizationGateway authorization;
  late FakeAuthorizationStateGateway pendingState;
  late FakeLinkedAccountGateway accounts;

  setUp(() {
    authorization = FakeBankAuthorizationGateway();
    pendingState = FakeAuthorizationStateGateway();
    accounts = FakeLinkedAccountGateway();
  });

  group('StartBankAuthorizationUseCase', () {
    late StartBankAuthorizationUseCase start;

    setUp(() {
      start = StartBankAuthorizationUseCase(
        authorization,
        pendingState,
        FixedStateGenerator('9b2c'),
        FixedClock(DateTime(2026, 10, 5, 14)),
      );
    });

    test('remembers a fresh state and asks for the longest access the bank allows', () async {
      const bank = Bank(name: 'Banque de Test', country: 'FR', maximumConsentValidity: Duration(days: 180));

      final url = await start(bank, redirectUrl: 'depenses://bank-callback');

      expect(url, authorization.authorizationUrl);
      expect(pendingState.value, '9b2c');
      final started = authorization.started.single;
      expect(started.state, '9b2c');
      expect(started.redirectUrl, 'depenses://bank-callback');
      expect(started.validUntil, DateTime(2026, 10, 5).add(const Duration(days: 180)));
    });

    test('falls back on 90 days when the bank gives no maximum validity', () async {
      await start(
        const Bank(name: 'Crédit Exemple', country: 'FR'),
        redirectUrl: 'http://localhost:8765/bank-callback',
      );

      expect(authorization.started.single.validUntil, DateTime(2026, 10, 5).add(Bank.defaultConsentValidity));
    });
  });

  group('CompleteBankAuthorizationUseCase', () {
    late CompleteBankAuthorizationUseCase complete;

    setUp(() => complete = CompleteBankAuthorizationUseCase(authorization, pendingState, accounts));

    test('links the authorized accounts when the state matches', () async {
      pendingState.value = 'state-1';

      final linked = await complete(code: 'code-1', state: 'state-1');

      expect(linked, authorization.accountsToLink);
      expect(authorization.completedCodes, ['code-1']);
      expect(accounts.all(), authorization.accountsToLink);
      expect(pendingState.value, isNull);
    });

    test('rejects a callback whose state differs from the pending one', () async {
      pendingState.value = 'state-1';

      await expectLater(complete(code: 'code-1', state: 'forged'), throwsA(isA<BankAuthorizationRejectedException>()));

      expect(authorization.completedCodes, isEmpty);
      expect(accounts.all(), isEmpty);
      expect(pendingState.value, isNull);
    });

    test('rejects a callback when no authorization is pending', () async {
      await expectLater(complete(code: 'code-1', state: 'state-1'), throwsA(isA<BankAuthorizationRejectedException>()));
    });

    test('reports a cancellation when the bank sends no code', () async {
      pendingState.value = 'state-1';

      await expectLater(
        complete(state: 'state-1', error: 'access_denied'),
        throwsA(isA<BankAuthorizationCancelledException>().having((e) => e.reason, 'reason', 'access_denied')),
      );

      expect(accounts.all(), isEmpty);
      expect(pendingState.value, isNull);
    });

    test('renewing an expired account keeps its last synchronization', () async {
      final lastSync = DateTime(2026, 9, 1, 8);
      accounts.accounts.add(
        linkedAccount(
          validUntil: DateTime(2026, 9, 2),
          lastSyncedAt: lastSync,
          lastBankBalance: 812.4,
          isRevoked: true,
        ),
      );
      authorization.accountsToLink = [linkedAccount(validUntil: DateTime(2027, 4, 1))];
      pendingState.value = 'state-1';

      await complete(code: 'code-2', state: 'state-1');

      final renewed = accounts.all().single;
      expect(renewed.accessValidUntil, DateTime(2027, 4, 1));
      expect(renewed.lastSyncedAt, lastSync);
      expect(renewed.lastBankBalance, 812.4);
      expect(renewed.isRevoked, isFalse);
    });
  });
}
