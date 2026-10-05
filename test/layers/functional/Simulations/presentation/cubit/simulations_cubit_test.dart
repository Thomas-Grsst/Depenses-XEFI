import 'package:depenses/layers/functional/Simulations/domain/use_cases/create_scenario_use_case.dart';
import 'package:depenses/layers/functional/Simulations/presentation/cubit/simulations_cubit.dart';
import 'package:depenses/layers/functional/Simulations/presentation/cubit/simulations_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';
import '../../simulations_fixtures.dart';

void main() {
  late TestDependencies dependencies;

  Future<void> createScenarios(int count) async {
    for (var i = 0; i < count; i++) {
      await dependencies.get<CreateScenarioUseCase>()(
        title: 'S$i',
        description: '',
        hypotheses: [rentHypothesis(newAmount: 710.0 + i)],
      );
    }
  }

  setUp(
    () => dependencies = TestDependencies(
      today: simulationsToday,
      data: {
        'settings': {'income': 2000},
      },
    ),
  );
  tearDown(() => dependencies.dispose());

  test('starts with the two latest scenarios picked and compared', () async {
    await createScenarios(3);
    final cubit = dependencies.get<SimulationsCubit>();

    expect(cubit.state.status, SimulationsStatus.ready);
    expect(cubit.state.pickedIds, ['id2', 'id3']);
    expect(cubit.state.comparison?.picked.map((p) => p.position), [1, 2]);
    expect(cubit.state.badges.leadOf(cubit.state.scenarios.first).colorIndex, 0);
    await cubit.close();
  });

  test('picking a third scenario drops the oldest pick', () async {
    await createScenarios(3);
    final cubit = dependencies.get<SimulationsCubit>()..toggle('id1');

    expect(cubit.state.pickedIds, ['id3', 'id1']);
    await cubit.close();
  });

  test('toggling a picked scenario unpicks it', () async {
    await createScenarios(2);
    final cubit = dependencies.get<SimulationsCubit>()..toggle('id1');

    expect(cubit.state.pickedIds, ['id2']);
    expect(cubit.state.comparison?.picked.single.scenario.id, 'id2');
    await cubit.close();
  });

  test('deleting a scenario reloads the list and forgets its pick', () async {
    await createScenarios(2);
    final cubit = dependencies.get<SimulationsCubit>();

    await cubit.delete('id2');

    expect(cubit.state.scenarios.map((s) => s.id), ['id1']);
    expect(cubit.state.pickedIds, ['id1']);
    await cubit.close();
  });

  test('without scenarios nothing is picked', () async {
    final cubit = dependencies.get<SimulationsCubit>();

    expect(cubit.state.hasScenarios, isFalse);
    expect(cubit.state.comparison?.picked, isEmpty);
    await cubit.close();
  });
}
