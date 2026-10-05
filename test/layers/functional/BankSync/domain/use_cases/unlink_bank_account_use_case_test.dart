import 'package:depenses/layers/functional/BankSync/domain/use_cases/unlink_bank_account_use_case.dart';
import 'package:depenses/layers/functional/Expenses/domain/gateways/expense_gateway.dart';
import 'package:depenses/layers/technical/OpenBanking/enable_banking_errors.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';
import '../../support/bank_link_fakes.dart';

void main() {
  late FakeBankAuthorizationGateway authorization;
  late FakeLinkedAccountGateway accounts;
  late UnlinkBankAccountUseCase unlink;

  setUp(() {
    authorization = FakeBankAuthorizationGateway();
    accounts = FakeLinkedAccountGateway([linkedAccount(), linkedAccount(uid: 'account-2')]);
    unlink = UnlinkBankAccountUseCase(authorization, accounts);
  });

  test('revokes the access and forgets only that account', () async {
    final account = accounts.all().first;

    await unlink(account);

    expect(authorization.revoked, [account]);
    expect(accounts.all().map((known) => known.uid), ['account-2']);
  });

  test('keeps the account when the bank cannot be reached', () async {
    authorization.error = const BankUnavailableException('offline');

    await expectLater(unlink(accounts.all().first), throwsA(isA<BankUnavailableException>()));

    expect(accounts.all(), hasLength(2));
  });

  test('imported expenses stay in the ledger after unlinking', () async {
    final dependencies = TestDependencies(
      data: {
        'expenses': [
          {
            'id': 'e1',
            'name': 'Carrefour',
            'amount': 42.5,
            'date': '2026-10-02',
            'cat': 'ali',
            'labels': <String>[],
            'origin': 'bank',
            'bankTxId': 'tx-1',
          },
        ],
        'bankAccounts': [
          {
            'uid': 'account-1',
            'bank': 'Banque de Test',
            'country': 'FR',
            'label': 'Compte',
            'validUntil': '2027-01-03',
          },
        ],
      },
    );
    addTearDown(dependencies.dispose);
    final useCase = dependencies.get<UnlinkBankAccountUseCase>();

    await useCase(linkedAccount());

    expect(dependencies.store.snapshot['bankAccounts'], isEmpty);
    expect(dependencies.get<ExpenseGateway>().all().map((expense) => expense.id), ['e1']);
  });
}
