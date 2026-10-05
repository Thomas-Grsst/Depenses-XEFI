import 'package:depenses/layers/functional/Account/domain/use_cases/get_account_settings_use_case.dart';
import 'package:depenses/layers/functional/Onboarding/domain/use_cases/complete_onboarding_use_case.dart';
import 'package:depenses/layers/functional/Onboarding/onboarding_dependencies.dart';
import 'package:depenses/layers/functional/Profile/domain/use_cases/is_onboarded_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';

void main() {
  late TestDependencies dependencies;

  setUp(() {
    dependencies = TestDependencies(today: DateTime(2026, 10, 15));
    registerOnboardingDependencies(dependencies.getIt);
  });
  tearDown(() => dependencies.dispose());

  test('saves the name, salary, pay day and starting balance', () async {
    await dependencies.get<CompleteOnboardingUseCase>()(name: 'Camille', income: 2400, payDay: 28, balance: 1250.4);

    final account = dependencies.get<GetAccountSettingsUseCase>()();
    expect(dependencies.get<IsOnboardedUseCase>()(), isTrue);
    expect(account.income, 2400);
    expect(account.payDay, 28);
    expect(account.balance, 1250.4);
    expect(account.balanceDate, DateTime(2026, 10, 15));
  });

  test('salary and balance are optional', () async {
    await dependencies.get<CompleteOnboardingUseCase>()(name: 'Camille', income: null, payDay: 1, balance: null);

    final account = dependencies.get<GetAccountSettingsUseCase>()();
    expect(account.income, 0);
    expect(account.hasBalance, isFalse);
  });
}
