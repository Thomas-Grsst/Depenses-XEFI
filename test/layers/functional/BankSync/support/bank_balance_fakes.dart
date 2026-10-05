import 'package:depenses/layers/functional/BankSync/domain/entities/balance_gap.dart';
import 'package:depenses/layers/functional/BankSync/domain/use_cases/align_balance_on_bank_use_case.dart';
import 'package:depenses/layers/functional/BankSync/domain/use_cases/get_balance_gap_use_case.dart';

class FakeGetBalanceGap implements GetBalanceGapUseCase {
  FakeGetBalanceGap([this.gap]);

  BalanceGap? gap;

  @override
  BalanceGap? call() => gap;
}

class FakeAlignBalanceOnBank implements AlignBalanceOnBankUseCase {
  FakeAlignBalanceOnBank(this._gaps);

  final FakeGetBalanceGap _gaps;
  int calls = 0;

  @override
  Future<void> call() async {
    calls++;
    final gap = _gaps.gap;
    if (gap != null) _gaps.gap = BalanceGap(bankBalance: gap.bankBalance, appBalance: gap.bankBalance);
  }
}
