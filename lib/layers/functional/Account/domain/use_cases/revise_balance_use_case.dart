import 'get_account_settings_use_case.dart';
import 'get_balance_use_case.dart';
import 'set_balance_use_case.dart';

const _balanceTolerance = 0.005;

class ReviseBalanceUseCase {
  ReviseBalanceUseCase(this._settings, this._balance, this._setBalance);

  final GetAccountSettingsUseCase _settings;
  final GetBalanceUseCase _balance;
  final SetBalanceUseCase _setBalance;

  Future<bool> call(double amount) async {
    if (_settings().hasBalance && (amount - _balance()).abs() < _balanceTolerance) return false;
    await _setBalance(amount);
    return true;
  }
}
