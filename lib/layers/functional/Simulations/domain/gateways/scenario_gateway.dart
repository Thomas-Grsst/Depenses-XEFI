import '../entities/scenario.dart';

abstract class ScenarioGateway {
  List<Scenario> all();

  Future<void> saveAll(List<Scenario> scenarios);
}
