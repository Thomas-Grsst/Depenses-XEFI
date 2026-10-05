import 'package:depenses/layers/functional/Account/domain/use_cases/set_balance_use_case.dart';
import 'package:depenses/layers/functional/Account/presentation/cubit/account_summary_cubit.dart';
import 'package:depenses/layers/functional/Account/presentation/cubit/account_summary_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';

void main() {
  late TestDependencies dependencies;
  late AccountSummaryCubit cubit;

  setUp(() {
    dependencies = TestDependencies(
      today: DateTime(2026, 10, 15),
      data: {
        'settings': {'income': 1800, 'payDay': 1},
      },
    );
    cubit = dependencies.get<AccountSummaryCubit>();
  });
  tearDown(() async {
    await cubit.close();
    await dependencies.dispose();
  });

  test('loading exposes the summary and today', () {
    final state = cubit.state;

    expect(state.status, AccountSummaryStatus.ready);
    expect(state.today, DateTime(2026, 10, 15));
    expect(state.summary.hasBalance, isFalse);
    expect(state.summary.nextPayday, DateTime(2026, 11, 1));
  });

  test('entering a balance refreshes the summary', () async {
    await dependencies.get<SetBalanceUseCase>()(640);

    expect(cubit.state.summary.hasBalance, isTrue);
    expect(cubit.state.summary.balance, 640);
  });
}
