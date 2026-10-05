import 'package:depenses/layers/functional/Forecast/presentation/cubit/compare_cubit.dart';
import 'package:depenses/layers/functional/Forecast/presentation/cubit/compare_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';
import '../../forecast_seed.dart';

void main() {
  late TestDependencies dependencies;
  late CompareCubit cubit;

  setUp(() {
    dependencies = TestDependencies(
      today: DateTime(2026, 10, 15),
      data: {
        'expenses': [
          forecastExpense('a', 50, '2026-10-03'),
          forecastExpense('b', 80, '2026-09-05'),
          forecastExpense('c', 40, '2026-09-25', category: 'tra'),
          forecastExpense('d', 70, '2026-07-05'),
        ],
      },
    );
    cubit = dependencies.get<CompareCubit>();
  });
  tearDown(() async {
    await cubit.close();
    await dependencies.dispose();
  });

  test('starts on the previous month, up to the same day', () {
    final state = cubit.state;

    expect(state.status, CompareStatus.ready);
    expect(state.isToDate, isTrue);
    expect(state.referenceMonth, DateTime(2026, 9));
    expect(state.comparison?.referenceTotal, 80);
    expect(state.comparableMonths, [DateTime(2026, 9), DateTime(2026, 7)]);
    expect(state.categories.keys, contains('tra'));
  });

  test('toggling compares with the whole reference month', () {
    cubit.toggleToDate();

    expect(cubit.state.isToDate, isFalse);
    expect(cubit.state.comparison?.referenceTotal, 120);
  });

  test('selecting another month keeps the to-date choice', () {
    cubit
      ..toggleToDate()
      ..selectReferenceMonth(DateTime(2026, 7));

    expect(cubit.state.referenceMonth, DateTime(2026, 7));
    expect(cubit.state.isToDate, isFalse);
    expect(cubit.state.comparison?.referenceTotal, 70);
  });
}
