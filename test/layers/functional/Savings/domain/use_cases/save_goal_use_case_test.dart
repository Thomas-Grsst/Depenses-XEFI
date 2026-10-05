import 'package:depenses/layers/functional/Savings/domain/entities/goal.dart';
import 'package:depenses/layers/functional/Savings/domain/gateways/goal_gateway.dart';
import 'package:depenses/layers/functional/Savings/domain/use_cases/save_goal_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';
import '../../savings_seed.dart';

void main() {
  late TestDependencies dependencies;
  late SaveGoalUseCase save;

  setUp(() {
    dependencies = TestDependencies(
      data: {
        'goals': [savingsGoal('g1', 'Vacances', target: 1500, saved: 200, monthly: 100)],
      },
    );
    save = dependencies.get<SaveGoalUseCase>();
  });
  tearDown(() => dependencies.dispose());

  List<Goal> goals() => dependencies.get<GoalGateway>().all();

  test('a goal without target is not saved', () async {
    final isSaved = await save(name: 'Voiture', target: 0, saved: 0, monthly: 0, fallbackName: 'Objectif');

    expect(isSaved, isFalse);
    expect(goals(), hasLength(1));
  });

  test('a new goal gets a trimmed name, or the fallback name when blank', () async {
    await save(name: '  Voiture ', target: 4000, saved: 0, monthly: 150, fallbackName: 'Objectif');
    await save(name: '   ', target: 300, saved: 10, monthly: 0, fallbackName: 'Objectif');

    expect(goals().map((g) => g.name), ['Vacances', 'Voiture', 'Objectif']);
    expect(goals()[1].monthly, 150);
  });

  test('an existing goal is updated in place', () async {
    await save(existing: goals().single, name: 'Été', target: 1800, saved: 300, monthly: 120, fallbackName: 'Objectif');

    expect(goals().single, const Goal(id: 'g1', name: 'Été', target: 1800, saved: 300, monthly: 120));
  });
}
