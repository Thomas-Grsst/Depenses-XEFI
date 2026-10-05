import '../gateways/detection_setting_gateway.dart';

class SetDetectionEnabledUseCase {
  SetDetectionEnabledUseCase(this._settings);

  final DetectionSettingGateway _settings;

  Future<void> call(bool isEnabled) => _settings.setEnabled(isEnabled);
}
