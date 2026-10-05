import '../entities/scenario.dart';
import '../gateways/scenario_gateway.dart';

class GetScenariosUseCase {
  GetScenariosUseCase(this._scenarios);

  final ScenarioGateway _scenarios;

  List<Scenario> call() => _scenarios.all();
}
