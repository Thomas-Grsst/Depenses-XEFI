import 'package:depenses/layers/functional/Expenses/domain/use_cases/set_round_up_enabled_use_case.dart';
import 'package:depenses/layers/functional/Savings/presentation/cubit/savings_summary_cubit.dart';
import 'package:depenses/layers/functional/Savings/presentation/cubit/savings_summary_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';
import '../../savings_seed.dart';

void main() {
  late TestDependencies dependencies;

  tearDown(() => dependencies.dispose());

  test('exposes the month round-ups and the latest rounded expense', () async {
    dependencies = TestDependencies(
      today: DateTime(2026, 10, 15),
      data: {
        'expenses': [
          savingsExpense('a', 'Pain', 1.25, '2026-10-01', roundUp: 0.75),
          savingsExpense('b', 'Café', 2.5, '2026-10-09', roundUp: 0.5),
          savingsExpense('c', 'Loyer', 800, '2026-10-10'),
          savingsExpense('d', 'Livre', 9.5, '2026-09-10', roundUp: 0.5),
        ],
      },
    );
    final cubit = dependencies.get<SavingsSummaryCubit>();

    expect(cubit.state.status, SavingsSummaryStatus.ready);
    expect(cubit.state.month, DateTime(2026, 10));
    expect(cubit.state.summary.thisMonth, 1.25);
    expect(cubit.state.summary.total, 1.75);
    expect(cubit.state.lastRounded?.id, 'b');
    expect(cubit.state.isCardVisible, isTrue);
    await cubit.close();
  });

  test('the card hides when round-ups are off and nothing was ever rounded', () async {
    dependencies = TestDependencies(today: DateTime(2026, 10, 15));
    final cubit = dependencies.get<SavingsSummaryCubit>();
    expect(cubit.state.isCardVisible, isTrue);

    await dependencies.get<SetRoundUpEnabledUseCase>()(false);

    expect(cubit.state.isCardVisible, isFalse);
    expect(cubit.state.lastRounded, isNull);
    await cubit.close();
  });
}
