import 'package:depenses/layers/technical/Storage/document_store.dart';
import 'package:depenses/layers/technical/Storage/json_reading.dart';

import '../../domain/gateways/detection_setting_gateway.dart';

class DetectionSettingGatewayImpl implements DetectionSettingGateway {
  DetectionSettingGatewayImpl(this._store);

  final DocumentStore _store;

  @override
  bool isEnabled() => _store.readSettings().flag('detection', fallback: true);

  @override
  Future<void> setEnabled(bool isEnabled) => _store.mergeSettings({'detection': isEnabled});

  @override
  List<String> ignoredKeys() => _store.readSettings().strings('ignored');

  @override
  Future<void> ignore(String key) => _store.mergeSettings({
    'ignored': [...ignoredKeys(), key],
  });

  @override
  Future<void> reset() => _store.mergeSettings({'detection': true, 'ignored': <String>[]});
}
