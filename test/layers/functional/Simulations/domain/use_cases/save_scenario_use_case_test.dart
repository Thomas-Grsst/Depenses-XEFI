import 'package:depenses/layers/functional/Simulations/domain/use_cases/get_scenarios_use_case.dart';
import 'package:depenses/layers/functional/Simulations/domain/use_cases/save_scenario_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';
import '../../simulations_fixtures.dart';

void main() {
  late TestDependencies dependencies;

  setUp(() => dependencies = TestDependencies(today: simulationsToday));
  tearDown(() => dependencies.dispose());

  test('saves a trimmed scenario dated today', () async {
    await dependencies.get<SaveScenarioUseCase>()(
      title: '  Loyer à 900  ',
      description: ' Déménagement ',
      fallbackTitle: 'Simulation 1',
      hypotheses: [rentHypothesis()],
    );

    final saved = dependencies.get<GetScenariosUseCase>()().single;
    expect(saved.title, 'Loyer à 900');
    expect(saved.description, 'Déménagement');
    expect(saved.createdAt, simulationsToday);
    expect(saved.hypotheses, [rentHypothesis()]);
  });

  test('a blank title uses the fallback title', () async {
    await dependencies.get<SaveScenarioUseCase>()(
      title: ' ',
      description: '',
      fallbackTitle: 'Simulation 1',
      hypotheses: [rentHypothesis()],
    );

    expect(dependencies.get<GetScenariosUseCase>()().single.title, 'Simulation 1');
  });
}
