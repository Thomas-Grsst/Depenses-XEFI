import 'package:depenses/layers/technical/Storage/document_store.dart';
import 'package:depenses/layers/technical/Storage/json_reading.dart';
import 'package:depenses/layers/technical/Storage/ledger_section.dart';

import '../../domain/entities/scenario.dart';
import '../../domain/gateways/scenario_gateway.dart';
import '../models/scenario_model.dart';

class ScenarioGatewayImpl implements ScenarioGateway {
  ScenarioGatewayImpl(this._store);

  final DocumentStore _store;

  @override
  List<Scenario> all() => [
    for (final json in jsonRecords(_store.read(LedgerSection.scenarios))) ScenarioModel.fromJson(json),
  ];

  @override
  Future<void> saveAll(List<Scenario> scenarios) =>
      _store.write(LedgerSection.scenarios, [for (final s in scenarios) ScenarioModel.toJson(s)]);
}
