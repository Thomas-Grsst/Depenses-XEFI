import 'package:depenses/layers/functional/Account/domain/gateways/account_gateway.dart';
import 'package:depenses/layers/functional/Account/presentation/cubit/account_cubit.dart';
import 'package:depenses/layers/functional/Account/presentation/cubit/account_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';

void main() {
  late TestDependencies dependencies;
  late AccountCubit cubit;

  setUp(() {
    dependencies = TestDependencies(
      today: DateTime(2026, 10, 15),
      data: {
        'settings': {'income': 2000, 'payDay': 28, 'balance': 700, 'balanceDate': '2026-10-10'},
      },
    );
    cubit = dependencies.get<AccountCubit>();
  });
  tearDown(() async {
    await cubit.close();
    await dependencies.dispose();
  });

  test('loading exposes the account summary and the stored pay day', () {
    final state = cubit.state;

    expect(state.status, AccountStatus.ready);
    expect(state.isLoaded, isTrue);
    expect(state.payDay, 28);
    expect(state.summary.balance, 700);
    expect(state.stats?.today, DateTime(2026, 10, 15));
  });

  test('the chosen pay day survives a refresh until it is saved', () async {
    cubit.selectPayDay(3);
    await dependencies.get<AccountGateway>().save(dependencies.get<AccountGateway>().get().copyWith(income: 2100));

    expect(cubit.state.payDay, 3);
    expect(cubit.state.summary.income, 2100);
  });

  test('saving stores the income, the pay day and the new balance', () async {
    cubit.selectPayDay(5);

    await cubit.save(income: 2500, balance: 1200, isBalanceCleared: false);

    final settings = dependencies.get<AccountGateway>().get();
    expect(cubit.state.status, AccountStatus.saved);
    expect(settings.income, 2500);
    expect(settings.payDay, 5);
    expect(settings.balance, 1200);
    expect(settings.balanceDate, DateTime(2026, 10, 15));
  });

  test('saving with an empty balance clears it', () async {
    await cubit.save(income: 2000, balance: null, isBalanceCleared: true);

    expect(dependencies.get<AccountGateway>().get().hasBalance, isFalse);
    expect(cubit.state.summary.hasBalance, isFalse);
  });

  test('saving with an unreadable balance keeps the previous one', () async {
    await cubit.save(income: 2000, balance: null, isBalanceCleared: false);

    expect(dependencies.get<AccountGateway>().get().balance, 700);
  });
}
