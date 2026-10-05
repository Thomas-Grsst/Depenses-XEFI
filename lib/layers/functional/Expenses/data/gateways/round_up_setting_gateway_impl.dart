import 'package:depenses/layers/technical/Storage/document_store.dart';
import 'package:depenses/layers/technical/Storage/json_reading.dart';

import '../../domain/gateways/round_up_setting_gateway.dart';

class RoundUpSettingGatewayImpl implements RoundUpSettingGateway {
  RoundUpSettingGatewayImpl(this._store);

  final DocumentStore _store;

  @override
  bool isEnabled() => _store.readSettings().flag('roundUp', fallback: true);

  @override
  Future<void> setEnabled(bool isEnabled) => _store.mergeSettings({'roundUp': isEnabled});
}
