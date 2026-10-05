import '../gateways/detection_setting_gateway.dart';

class GetDetectionEnabledUseCase {
  GetDetectionEnabledUseCase(this._settings);

  final DetectionSettingGateway _settings;

  bool call() => _settings.isEnabled();
}
