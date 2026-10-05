import '../gateways/scenario_gateway.dart';

class DeleteScenarioUseCase {
  DeleteScenarioUseCase(this._scenarios);

  final ScenarioGateway _scenarios;

  Future<void> call(String id) => _scenarios.saveAll(_scenarios.all().where((s) => s.id != id).toList());
}
