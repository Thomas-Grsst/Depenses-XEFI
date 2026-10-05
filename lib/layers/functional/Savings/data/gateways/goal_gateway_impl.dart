import 'package:depenses/layers/technical/Storage/document_store.dart';
import 'package:depenses/layers/technical/Storage/json_reading.dart';
import 'package:depenses/layers/technical/Storage/ledger_section.dart';

import '../../domain/entities/goal.dart';
import '../../domain/gateways/goal_gateway.dart';
import '../models/goal_model.dart';

class GoalGatewayImpl implements GoalGateway {
  GoalGatewayImpl(this._store);

  final DocumentStore _store;

  @override
  List<Goal> all() => [for (final json in jsonRecords(_store.read(LedgerSection.goals))) GoalModel.fromJson(json)];

  @override
  Future<void> saveAll(List<Goal> goals) =>
      _store.write(LedgerSection.goals, [for (final g in goals) GoalModel.toJson(g)]);
}
