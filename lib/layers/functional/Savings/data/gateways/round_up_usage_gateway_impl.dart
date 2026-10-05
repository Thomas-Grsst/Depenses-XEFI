import 'package:depenses/layers/technical/Storage/document_store.dart';
import 'package:depenses/layers/technical/Storage/json_reading.dart';

import '../../domain/gateways/round_up_usage_gateway.dart';

class RoundUpUsageGatewayImpl implements RoundUpUsageGateway {
  RoundUpUsageGatewayImpl(this._store);

  final DocumentStore _store;

  @override
  double used() => _store.readSettings().decimal('roundUpUsed');

  @override
  Future<void> setUsed(double used) => _store.mergeSettings({'roundUpUsed': used});
}
