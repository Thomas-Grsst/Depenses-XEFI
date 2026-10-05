import 'package:depenses/layers/functional/Simulations/domain/use_cases/get_scenarios_use_case.dart';
import 'package:depenses/layers/functional/Simulations/presentation/cubit/simulation_cubit.dart';
import 'package:depenses/layers/functional/Simulations/presentation/cubit/simulation_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';
import '../../simulations_fixtures.dart';

void main() {
  late TestDependencies dependencies;
  late SimulationCubit cubit;

  setUp(() {
    dependencies = TestDependencies(
      today: simulationsToday,
      data: {
        'settings': {'income': 2000},
        'recs': [recurrenceJson('rent', 'Loyer', 700, 'month'), recurrenceJson('phone', 'Forfait', 20, 'month')],
      },
    );
    cubit = dependencies.get<SimulationCubit>();
  });
  tearDown(() async {
    await cubit.close();
    await dependencies.dispose();
  });

  test('opening a blank simulation offers every recurrence and no impact', () {
    cubit.open(null);

    expect(cubit.state.status, SimulationStatus.editing);
    expect(cubit.state.hasHypotheses, isFalse);
    expect(cubit.state.hasRecurrences, isTrue);
    expect(cubit.state.availableRecurrences.map((r) => r.id), ['rent', 'phone']);
    expect(cubit.state.impact?.isUnchanged, isTrue);
    expect(cubit.state.impact?.fixedMonthly, 720);
  });

  test('opening a saved scenario starts from its hypotheses', () {
    cubit.open(scenarioWith('s', [rentHypothesis()]));

    expect(cubit.state.source?.id, 's');
    expect(cubit.state.hypotheses, [rentHypothesis()]);
    expect(cubit.state.availableRecurrences.map((r) => r.id), ['phone']);
    expect(cubit.state.impact?.monthlyDelta, 200);
  });

  test('adding a recurrence then stepping and sliding updates the impact', () {
    cubit
      ..open(null)
      ..addRecurrence(cubit.state.availableRecurrences.first)
      ..step(0, 1);

    expect(cubit.state.hypotheses.single.newAmount, 710);
    expect(cubit.state.impact?.monthlyDelta, 10);

    cubit.slide(0, 903);

    expect(cubit.state.hypotheses.single.newAmount, 900);
    expect(cubit.state.badges.of('Loyer', 'log').colorIndex, 0);
  });

  test('a cut charge cannot be stepped until it is kept again', () {
    cubit
      ..open(scenarioWith('s', [rentHypothesis(newAmount: 700)]))
      ..keep(0, false)
      ..step(0, 1);

    expect(cubit.state.hypotheses.single.newAmount, 700);
    expect(cubit.state.impact?.monthlyDelta, -700);

    cubit.keep(0, true);
    expect(cubit.state.impact?.monthlyDelta, 0);
  });

  test('new charges, removal and reset edit the hypothesis list', () {
    cubit
      ..open(null)
      ..addNewCharge(name: 'Crèche', monthlyAmount: 300, fallbackName: 'Nouvelle charge')
      ..addNewCharge(name: 'Rien', monthlyAmount: null, fallbackName: 'Nouvelle charge');

    expect(cubit.state.hypotheses.single.name, 'Crèche');
    expect(cubit.state.impact?.monthlyDelta, 300);

    cubit
      ..addRecurrence(cubit.state.availableRecurrences.first)
      ..remove(0);
    expect(cubit.state.hypotheses.single.recurrenceId, 'rent');

    cubit.reset();
    expect(cubit.state.hasHypotheses, isFalse);
  });

  test('saving creates a scenario and reports it', () async {
    cubit.open(scenarioWith('s', [rentHypothesis()]));

    await cubit.save(title: '', description: 'Plus grand', fallbackTitle: 'Simulation 1');

    expect(cubit.state.status, SimulationStatus.saved);
    final saved = dependencies.get<GetScenariosUseCase>()().single;
    expect(saved.title, 'Simulation 1');
    expect(saved.description, 'Plus grand');
    expect(cubit.state.scenarioCount, 1);
  });
}
