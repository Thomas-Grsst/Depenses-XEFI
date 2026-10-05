import '../entities/expense.dart';
import '../entities/round_up.dart';
import '../gateways/round_up_setting_gateway.dart';

class PreviewRoundUpUseCase {
  PreviewRoundUpUseCase(this._roundUp);

  final RoundUpSettingGateway _roundUp;

  double call({required double? amount, required bool isRecurring, Expense? original}) {
    if (amount == null || isRecurring || (original?.isRecurring ?? false)) return 0;
    final appliesRoundUp = _roundUp.isEnabled() || (original?.roundUp ?? 0) > 0;
    return appliesRoundUp ? roundUpOf(amount) : 0;
  }
}
