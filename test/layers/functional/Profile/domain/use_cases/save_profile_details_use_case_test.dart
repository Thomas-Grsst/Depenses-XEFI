import 'package:depenses/layers/functional/Account/domain/use_cases/get_account_settings_use_case.dart';
import 'package:depenses/layers/functional/Profile/domain/use_cases/get_profile_name_use_case.dart';
import 'package:depenses/layers/functional/Profile/domain/use_cases/save_profile_details_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';

void main() {
  late TestDependencies dependencies;

  setUp(() {
    dependencies = TestDependencies(
      today: DateTime(2026, 10, 15),
      data: {
        'settings': {'name': 'Camille', 'income': 2000, 'payDay': 1, 'balance': 500, 'balanceDate': '2026-10-10'},
      },
    );
  });
  tearDown(() => dependencies.dispose());

  Future<void> save({String name = 'Camille', double? income = 2000, double? balance, bool isBalanceBlank = false}) =>
      dependencies.get<SaveProfileDetailsUseCase>()(
        name: name,
        income: income,
        payDay: 5,
        balance: balance,
        isBalanceBlank: isBalanceBlank,
      );

  test('saves the name, salary and pay day', () async {
    await save(name: ' Alex ', income: 2500, balance: 500);

    final account = dependencies.get<GetAccountSettingsUseCase>()();
    expect(dependencies.get<GetProfileNameUseCase>()(), 'Alex');
    expect(account.income, 2500);
    expect(account.payDay, 5);
  });

  test('a blank name keeps the current one and a missing salary means none', () async {
    await save(name: '  ', income: null, balance: 500);

    expect(dependencies.get<GetProfileNameUseCase>()(), 'Camille');
    expect(dependencies.get<GetAccountSettingsUseCase>()().income, 0);
  });

  test('an unchanged balance keeps its original date', () async {
    await save(balance: 500);

    expect(dependencies.get<GetAccountSettingsUseCase>()().balanceDate, DateTime(2026, 10, 10));
  });

  test('a new balance is recorded today', () async {
    await save(balance: 800);

    final account = dependencies.get<GetAccountSettingsUseCase>()();
    expect(account.balance, 800);
    expect(account.balanceDate, DateTime(2026, 10, 15));
  });

  test('a blank balance clears it', () async {
    await save(isBalanceBlank: true);

    expect(dependencies.get<GetAccountSettingsUseCase>()().hasBalance, isFalse);
  });
}
