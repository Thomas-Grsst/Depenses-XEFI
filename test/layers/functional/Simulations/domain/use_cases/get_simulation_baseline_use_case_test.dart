import 'package:depenses/layers/functional/Simulations/domain/use_cases/get_simulation_baseline_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';
import '../../simulations_fixtures.dart';

void main() {
  late TestDependencies dependencies;

  setUp(() {
    dependencies = TestDependencies(
      today: simulationsToday,
      data: {
        'settings': {'income': 2200, 'payDay': 1},
        'recs': [
          recurrenceJson('rent', 'Loyer', 700, 'month'),
          recurrenceJson('gym', 'Salle', 30, 'month', cat: 'san'),
        ],
        'envelopes': {'log': 800},
        'goals': [
          {'id': 'g1', 'name': 'Vacances', 'target': 1000, 'saved': 200, 'monthly': 100},
          {'id': 'g2', 'name': 'Voiture', 'target': 5000, 'saved': 0, 'monthly': 200},
        ],
      },
    );
  });
  tearDown(() => dependencies.dispose());

  test('gathers the fixed charges, income, envelopes and first goal', () {
    final baseline = dependencies.get<GetSimulationBaselineUseCase>()();

    expect(baseline.today, simulationsToday);
    expect(baseline.fixedMonthly, 730);
    expect(baseline.income, 2200);
    expect(baseline.hasIncome, isTrue);
    expect(baseline.envelopes['log']?.categoryName, 'Logement');
    expect(baseline.envelopes['log']?.budget, 800);
    expect(baseline.goal?.id, 'g1');
  });

  test('without goals nor income the baseline stays neutral', () async {
    await dependencies.dispose();
    dependencies = TestDependencies(today: simulationsToday);

    final baseline = dependencies.get<GetSimulationBaselineUseCase>()();

    expect(baseline.goal, isNull);
    expect(baseline.hasIncome, isFalse);
    expect(baseline.fixedMonthly, 0);
  });
}
