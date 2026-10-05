import 'package:depenses/layers/functional/Account/domain/use_cases/save_income_use_case.dart';
import 'package:depenses/layers/functional/Account/domain/use_cases/set_balance_use_case.dart';
import 'package:depenses/layers/functional/Profile/domain/use_cases/save_profile_name_use_case.dart';

class CompleteOnboardingUseCase {
  CompleteOnboardingUseCase(this._saveName, this._saveIncome, this._setBalance);

  final SaveProfileNameUseCase _saveName;
  final SaveIncomeUseCase _saveIncome;
  final SetBalanceUseCase _setBalance;

  Future<void> call({
    required String name,
    required double? income,
    required int payDay,
    required double? balance,
  }) async {
    await _saveIncome(income: income ?? 0, payDay: payDay);
    if (balance != null) await _setBalance(balance);
    await _saveName(name);
  }
}
