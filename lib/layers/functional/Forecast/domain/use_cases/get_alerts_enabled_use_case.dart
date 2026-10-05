import '../gateways/alert_setting_gateway.dart';

class GetAlertsEnabledUseCase {
  GetAlertsEnabledUseCase(this._settings);

  final AlertSettingGateway _settings;

  bool call() => _settings.isEnabled();
}
