import 'package:depenses/layers/functional/Categories/domain/entities/merchant_look.dart';
import 'package:depenses/layers/functional/Expenses/domain/use_cases/get_round_up_enabled_use_case.dart';
import 'package:depenses/layers/functional/Savings/presentation/cubit/savings_cubit.dart';
import 'package:depenses/layers/functional/Savings/presentation/cubit/savings_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';
import '../../savings_seed.dart';

void main() {
  late TestDependencies dependencies;
  late SavingsCubit cubit;

  setUp(() {
    dependencies = TestDependencies(
      today: DateTime(2026, 10, 15),
      data: {
        'expenses': [
          for (var i = 0; i < 10; i++) savingsExpense('e$i', 'Netflix', 9.5, '2026-10-0${i % 9 + 1}', roundUp: 0.5),
        ],
        'goals': [savingsGoal('g1', 'Vacances', target: 500, saved: 100)],
      },
    );
    cubit = dependencies.get<SavingsCubit>();
  });
  tearDown(() async {
    await cubit.close();
    await dependencies.dispose();
  });

  test('loading exposes the totals, the goals and the eight latest round-ups with their look', () {
    final state = cubit.state;

    expect(state.status, SavingsStatus.ready);
    expect(state.isRoundUpEnabled, isTrue);
    expect(state.summary.total, 5);
    expect(state.summary.available, 5);
    expect(state.goals.single.name, 'Vacances');
    expect(state.recentRounded, hasLength(8));
    expect(state.recentRounded.first.id, 'e8');
    expect(state.looks['e8'], const MerchantLook.letter('N'));
    expect(state.categories['ali']?.key, 'ali');
  });

  test('moving the round-ups to a goal funds it and empties what is available', () async {
    await cubit.moveToGoal(cubit.state.goals.single);

    expect(cubit.state.fundedGoal?.saved, 105);
    expect(cubit.state.goals.single.saved, 105);
    expect(cubit.state.summary.available, 0);
    expect(cubit.state.summary.used, 5);
  });

  test('turning round-ups off is stored and reloaded', () async {
    await cubit.setRoundUpEnabled(false);

    expect(dependencies.get<GetRoundUpEnabledUseCase>()(), isFalse);
    expect(cubit.state.isRoundUpEnabled, isFalse);
  });
}
