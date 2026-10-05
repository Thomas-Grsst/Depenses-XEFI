import 'package:depenses/layers/functional/Savings/presentation/cubit/savings_goals_cubit.dart';
import 'package:depenses/layers/functional/Savings/presentation/cubit/savings_goals_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';
import '../../savings_seed.dart';

void main() {
  late TestDependencies dependencies;
  late SavingsGoalsCubit cubit;

  setUp(() {
    dependencies = TestDependencies(
      today: DateTime(2026, 10, 15),
      data: {
        'goals': [savingsGoal('g1', 'Vacances')],
      },
    );
    cubit = dependencies.get<SavingsGoalsCubit>();
  });
  tearDown(() async {
    await cubit.close();
    await dependencies.dispose();
  });

  test('loading exposes the goals and today', () {
    expect(cubit.state.status, SavingsGoalsStatus.ready);
    expect(cubit.state.today, DateTime(2026, 10, 15));
    expect(cubit.state.goals.single.name, 'Vacances');
  });

  test('saving a new goal adds it to the list', () async {
    await cubit.save(name: '', target: 2000, saved: 0, monthly: 100, fallbackName: 'Objectif');

    expect(cubit.state.goals.map((g) => g.name), ['Vacances', 'Objectif']);
  });

  test('editing then deleting a goal updates the list', () async {
    await cubit.save(
      existing: cubit.state.goals.single,
      name: 'Japon',
      target: 3000,
      saved: 50,
      monthly: 200,
      fallbackName: 'Objectif',
    );
    expect(cubit.state.goals.single.name, 'Japon');

    await cubit.delete(cubit.state.goals.single);

    expect(cubit.state.goals, isEmpty);
  });
}
