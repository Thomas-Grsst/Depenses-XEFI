import 'package:depenses/layers/functional/BankSync/domain/entities/balance_gap.dart';
import 'package:depenses/layers/functional/BankSync/domain/gateways/linked_account_gateway.dart';
import 'package:depenses/layers/functional/BankSync/domain/use_cases/get_balance_gap_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';
import '../../support/bank_link_fakes.dart';

void main() {
  late TestDependencies dependencies;

  tearDown(() => dependencies.dispose());

  TestDependencies withAppBalance(double? balance) => TestDependencies(
    today: DateTime(2026, 10, 15),
    data: {
      if (balance != null) 'settings': {'balance': balance, 'balanceDate': '2026-10-15'},
    },
  );

  test('no bank balance known yet gives no gap', () async {
    dependencies = withAppBalance(1237);
    await dependencies.get<LinkedAccountGateway>().save(linkedAccount());

    expect(dependencies.get<GetBalanceGapUseCase>()(), isNull);
  });

  test('the bank balance is compared with the balance shown in the app', () async {
    dependencies = withAppBalance(1237);
    await dependencies.get<LinkedAccountGateway>().save(linkedAccount(lastBankBalance: 1180.50));

    final gap = dependencies.get<GetBalanceGapUseCase>()();

    expect(gap, const BalanceGap(bankBalance: 1180.50, appBalance: 1237));
    expect(gap!.difference, -56.50);
    expect(gap.isWorthAligning, isTrue);
  });

  test('the balances of every linked account are added up, revoked ones aside', () async {
    dependencies = withAppBalance(1000);
    final accounts = dependencies.get<LinkedAccountGateway>();
    await accounts.save(linkedAccount(uid: 'a', lastBankBalance: 800.10));
    await accounts.save(linkedAccount(uid: 'b', lastBankBalance: 200.20));
    await accounts.save(linkedAccount(uid: 'c', lastBankBalance: 5000, isRevoked: true));
    await accounts.save(linkedAccount(uid: 'd'));

    expect(dependencies.get<GetBalanceGapUseCase>()()!.bankBalance, 1000.30);
  });

  test('a gap of one euro or less is not worth aligning', () async {
    dependencies = withAppBalance(1237);
    await dependencies.get<LinkedAccountGateway>().save(linkedAccount(lastBankBalance: 1236));

    final gap = dependencies.get<GetBalanceGapUseCase>()()!;

    expect(gap.difference, -1);
    expect(gap.isWorthAligning, isFalse);
  });

  test('an app without balance is always offered the bank one', () async {
    dependencies = withAppBalance(null);
    await dependencies.get<LinkedAccountGateway>().save(linkedAccount(lastBankBalance: 0.50));

    final gap = dependencies.get<GetBalanceGapUseCase>()()!;

    expect(gap.hasAppBalance, isFalse);
    expect(gap.isWorthAligning, isTrue);
  });
}
