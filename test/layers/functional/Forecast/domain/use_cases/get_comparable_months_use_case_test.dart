import 'package:depenses/layers/functional/Forecast/domain/use_cases/get_comparable_months_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';
import '../../forecast_seed.dart';

void main() {
  late TestDependencies dependencies;

  tearDown(() => dependencies.dispose());

  test('lists the months with expenses, newest first, without the current month', () {
    dependencies = TestDependencies(
      today: DateTime(2026, 10, 15),
      data: {
        'expenses': [
          forecastExpense('a', 10, '2026-10-02'),
          forecastExpense('b', 10, '2026-06-02'),
          forecastExpense('c', 10, '2026-08-02'),
        ],
      },
    );

    expect(dependencies.get<GetComparableMonthsUseCase>()(), [DateTime(2026, 8), DateTime(2026, 6)]);
  });

  test('without past expenses there is nothing to compare with', () {
    dependencies = TestDependencies(today: DateTime(2026, 10, 15));

    expect(dependencies.get<GetComparableMonthsUseCase>()(), isEmpty);
  });
}
