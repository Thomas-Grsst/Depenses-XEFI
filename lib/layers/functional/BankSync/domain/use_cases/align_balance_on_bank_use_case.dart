import 'package:depenses/layers/functional/Account/domain/use_cases/set_balance_use_case.dart';

import 'get_balance_gap_use_case.dart';

class AlignBalanceOnBankUseCase {
  AlignBalanceOnBankUseCase(this._getGap, this._setBalance);

  final GetBalanceGapUseCase _getGap;
  final SetBalanceUseCase _setBalance;

  Future<void> call() async {
    final gap = _getGap();
    if (gap == null || !gap.isWorthAligning) return;
    await _setBalance(gap.bankBalance);
  }
}
