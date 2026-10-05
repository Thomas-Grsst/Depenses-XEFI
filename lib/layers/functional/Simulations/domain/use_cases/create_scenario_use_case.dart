import 'package:depenses/layers/technical/Calendar/clock.dart';
import 'package:depenses/layers/technical/Storage/id_generator.dart';

import '../entities/hypothesis.dart';
import '../entities/scenario.dart';
import '../gateways/scenario_gateway.dart';

class CreateScenarioUseCase {
  CreateScenarioUseCase(this._scenarios, this._ids, this._clock);

  final ScenarioGateway _scenarios;
  final IdGenerator _ids;
  final Clock _clock;

  Future<Scenario> call({
    required String title,
    required String description,
    required List<Hypothesis> hypotheses,
  }) async {
    final scenario = Scenario(
      id: _ids.next(),
      title: title,
      description: description,
      createdAt: _clock.today(),
      hypotheses: hypotheses,
    );
    await _scenarios.saveAll([..._scenarios.all(), scenario]);
    return scenario;
  }
}
