import 'package:depenses/layers/technical/Storage/document_store.dart';
import 'package:depenses/layers/technical/Storage/json_reading.dart';

import '../../domain/gateways/alert_setting_gateway.dart';

class AlertSettingGatewayImpl implements AlertSettingGateway {
  AlertSettingGatewayImpl(this._store);

  final DocumentStore _store;

  @override
  bool isEnabled() => _store.readSettings().flag('alerts', fallback: true);

  @override
  Future<void> setEnabled(bool isEnabled) => _store.mergeSettings({'alerts': isEnabled});
}
