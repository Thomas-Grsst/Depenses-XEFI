import 'package:depenses/layers/functional/Account/domain/use_cases/clear_balance_use_case.dart';
import 'package:depenses/layers/functional/Account/domain/use_cases/get_account_settings_use_case.dart';
import 'package:depenses/layers/functional/Account/domain/use_cases/get_balance_use_case.dart';
import 'package:depenses/layers/functional/Account/domain/use_cases/save_income_use_case.dart';
import 'package:depenses/layers/functional/Account/domain/use_cases/set_balance_use_case.dart';

import 'save_profile_name_use_case.dart';

const _negligibleBalanceChange = 0.005;

class SaveProfileDetailsUseCase {
  SaveProfileDetailsUseCase(
    this._saveName,
    this._saveIncome,
    this._account,
    this._balance,
    this._setBalance,
    this._clearBalance,
  );

  final SaveProfileNameUseCase _saveName;
  final SaveIncomeUseCase _saveIncome;
  final GetAccountSettingsUseCase _account;
  final GetBalanceUseCase _balance;
  final SetBalanceUseCase _setBalance;
  final ClearBalanceUseCase _clearBalance;

  Future<void> call({
    required String name,
    required double? income,
    required int payDay,
    required double? balance,
    required bool isBalanceBlank,
  }) async {
    if (name.trim().isNotEmpty) await _saveName(name);
    await _saveIncome(income: income ?? 0, payDay: payDay);
    if (isBalanceBlank) return _clearBalance();
    if (balance == null) return;
    final hasBalance = _account().hasBalance;
    if (!hasBalance || (balance - _balance()).abs() >= _negligibleBalanceChange) await _setBalance(balance);
  }
}
