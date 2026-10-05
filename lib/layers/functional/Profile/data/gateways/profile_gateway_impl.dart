import 'package:depenses/layers/technical/Storage/document_store.dart';
import 'package:depenses/layers/technical/Storage/json_reading.dart';

import '../../domain/gateways/profile_gateway.dart';

class ProfileGatewayImpl implements ProfileGateway {
  ProfileGatewayImpl(this._store);

  final DocumentStore _store;

  @override
  String name() => _store.readSettings().text('name');

  @override
  Future<void> saveName(String name) => _store.mergeSettings({'name': name});
}
