import '../gateways/round_up_setting_gateway.dart';

class SetRoundUpEnabledUseCase {
  SetRoundUpEnabledUseCase(this._roundUp);

  final RoundUpSettingGateway _roundUp;

  Future<void> call(bool isEnabled) => _roundUp.setEnabled(isEnabled);
}
