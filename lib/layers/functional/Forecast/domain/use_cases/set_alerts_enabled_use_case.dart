import '../gateways/alert_setting_gateway.dart';

class SetAlertsEnabledUseCase {
  SetAlertsEnabledUseCase(this._settings);

  final AlertSettingGateway _settings;

  Future<void> call(bool isEnabled) => _settings.setEnabled(isEnabled);
}
