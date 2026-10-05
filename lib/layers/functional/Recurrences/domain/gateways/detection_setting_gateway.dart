abstract class DetectionSettingGateway {
  bool isEnabled();

  Future<void> setEnabled(bool isEnabled);

  List<String> ignoredKeys();

  Future<void> ignore(String key);

  Future<void> reset();
}
