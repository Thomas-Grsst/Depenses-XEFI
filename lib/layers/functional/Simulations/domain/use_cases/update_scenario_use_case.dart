import '../entities/scenario.dart';
import '../gateways/scenario_gateway.dart';

class UpdateScenarioUseCase {
  UpdateScenarioUseCase(this._scenarios);

  final ScenarioGateway _scenarios;

  Future<void> call(Scenario scenario) =>
      _scenarios.saveAll([for (final s in _scenarios.all()) s.id == scenario.id ? scenario : s]);
}
