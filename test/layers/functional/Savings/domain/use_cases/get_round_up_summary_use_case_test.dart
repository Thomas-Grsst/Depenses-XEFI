import 'package:depenses/layers/functional/Savings/domain/entities/round_up_summary.dart';
import 'package:depenses/layers/functional/Savings/domain/use_cases/get_round_up_summary_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';
import '../../savings_seed.dart';

void main() {
  late TestDependencies dependencies;

  tearDown(() => dependencies.dispose());

  test('totals the round-ups, those of the month, what was used and what is left', () {
    dependencies = TestDependencies(
      data: {
        'expenses': [
          savingsExpense('a', 'Pain', 1.25, '2026-10-01', roundUp: 0.75),
          savingsExpense('b', 'Café', 2.5, '2026-09-05', roundUp: 0.5),
        ],
        'settings': {'roundUpUsed': 1.0},
      },
    );

    final summary = dependencies.get<GetRoundUpSummaryUseCase>()(DateTime(2026, 10));

    expect(summary, const RoundUpSummary(total: 1.25, thisMonth: 0.75, available: 0.25, used: 1));
  });

  test('the available amount never goes below zero', () {
    dependencies = TestDependencies(
      data: {
        'settings': {'roundUpUsed': 5.0},
      },
    );

    expect(dependencies.get<GetRoundUpSummaryUseCase>()(DateTime(2026, 10)).available, 0);
  });
}
