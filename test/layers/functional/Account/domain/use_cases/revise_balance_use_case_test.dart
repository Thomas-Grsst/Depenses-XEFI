import 'package:depenses/layers/functional/Account/domain/gateways/account_gateway.dart';
import 'package:depenses/layers/functional/Account/domain/use_cases/revise_balance_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';

void main() {
  late TestDependencies dependencies;

  tearDown(() => dependencies.dispose());

  test('a first balance is recorded today', () async {
    dependencies = TestDependencies(today: DateTime(2026, 10, 15));

    final isRevised = await dependencies.get<ReviseBalanceUseCase>()(850);

    final settings = dependencies.get<AccountGateway>().get();
    expect(isRevised, isTrue);
    expect(settings.balance, 850);
    expect(settings.balanceDate, DateTime(2026, 10, 15));
  });

  test('the same balance as the computed one is left untouched', () async {
    dependencies = TestDependencies(
      today: DateTime(2026, 10, 15),
      data: {
        'settings': {'balance': 500, 'balanceDate': '2026-10-01'},
      },
    );

    final isRevised = await dependencies.get<ReviseBalanceUseCase>()(500.001);

    expect(isRevised, isFalse);
    expect(dependencies.get<AccountGateway>().get().balanceDate, DateTime(2026, 10, 1));
  });

  test('a different balance replaces the previous one', () async {
    dependencies = TestDependencies(
      today: DateTime(2026, 10, 15),
      data: {
        'settings': {'balance': 500, 'balanceDate': '2026-10-01'},
      },
    );

    final isRevised = await dependencies.get<ReviseBalanceUseCase>()(420);

    expect(isRevised, isTrue);
    expect(dependencies.get<AccountGateway>().get().balance, 420);
    expect(dependencies.get<AccountGateway>().get().balanceDate, DateTime(2026, 10, 15));
  });
}
