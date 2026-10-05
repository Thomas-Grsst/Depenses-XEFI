import 'package:depenses/layers/functional/Account/domain/use_cases/get_account_settings_use_case.dart';
import 'package:depenses/layers/functional/Account/domain/use_cases/get_balance_use_case.dart';

import '../entities/balance_gap.dart';
import '../gateways/linked_account_gateway.dart';

class GetBalanceGapUseCase {
  GetBalanceGapUseCase(this._accounts, this._getSettings, this._getBalance);

  final LinkedAccountGateway _accounts;
  final GetAccountSettingsUseCase _getSettings;
  final GetBalanceUseCase _getBalance;

  BalanceGap? call() {
    final bankBalances = [
      for (final account in _accounts.all())
        if (!account.isRevoked) ?account.lastBankBalance,
    ];
    if (bankBalances.isEmpty) return null;
    final bankCents = bankBalances.fold(0, (total, balance) => total + (balance * 100).round());
    return BalanceGap(bankBalance: bankCents / 100, appBalance: _getSettings().hasBalance ? _getBalance() : null);
  }
}
