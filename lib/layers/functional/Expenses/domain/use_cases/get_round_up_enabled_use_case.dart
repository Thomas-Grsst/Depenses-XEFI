import '../gateways/round_up_setting_gateway.dart';

class GetRoundUpEnabledUseCase {
  GetRoundUpEnabledUseCase(this._roundUp);

  final RoundUpSettingGateway _roundUp;

  bool call() => _roundUp.isEnabled();
}
