import 'package:depenses/layers/functional/Account/domain/use_cases/get_account_summary_use_case.dart';
import 'package:depenses/layers/functional/Forecast/domain/use_cases/compute_month_stats_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';

void main() {
  late TestDependencies dependencies;

  tearDown(() => dependencies.dispose());

  test('summarises the balance, the next payday and the end-of-month estimate', () {
    dependencies = TestDependencies(
      today: DateTime(2026, 10, 15),
      data: {
        'settings': {'income': 2000, 'payDay': 25, 'balance': 1000, 'balanceDate': '2026-10-15'},
        'expenses': [
          {'id': 'a', 'name': 'Billet', 'amount': 40, 'date': '2026-10-20', 'cat': 'loi', 'labels': <String>[]},
        ],
      },
    );
    final stats = dependencies.get<ComputeMonthStatsUseCase>()();

    final summary = dependencies.get<GetAccountSummaryUseCase>()(stats);

    expect(summary.hasBalance, isTrue);
    expect(summary.balance, 1000);
    expect(summary.income, 2000);
    expect(summary.payDay, 25);
    expect(summary.nextPayday, DateTime(2026, 10, 25));
    expect(summary.payDatesLeftThisMonth, [DateTime(2026, 10, 25)]);
    expect(summary.futureNoted, 40);
    expect(summary.endOfMonth, 1000 + 2000 - (stats.forecast - stats.spent) - 40);
  });

  test('without balance nor income the summary is empty', () {
    dependencies = TestDependencies(today: DateTime(2026, 10, 15));
    final stats = dependencies.get<ComputeMonthStatsUseCase>()();

    final summary = dependencies.get<GetAccountSummaryUseCase>()(stats);

    expect(summary.hasBalance, isFalse);
    expect(summary.nextPayday, isNull);
    expect(summary.payDatesLeftThisMonth, isEmpty);
  });
}
