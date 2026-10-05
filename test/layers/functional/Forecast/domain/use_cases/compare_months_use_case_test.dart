import 'package:depenses/layers/functional/Forecast/domain/entities/category_move.dart';
import 'package:depenses/layers/functional/Forecast/domain/use_cases/compare_months_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';
import '../../forecast_seed.dart';

void main() {
  late TestDependencies dependencies;
  late CompareMonthsUseCase compare;

  setUp(() {
    dependencies = TestDependencies(
      today: DateTime(2026, 10, 15),
      data: {
        'expenses': [
          forecastExpense('a', 50, '2026-10-03'),
          forecastExpense('b', 30, '2026-10-10', category: 'loi'),
          forecastExpense('c', 20, '2026-10-20'),
          forecastExpense('d', 80, '2026-09-05'),
          forecastExpense('e', 40, '2026-09-25', category: 'tra'),
        ],
      },
    );
    compare = dependencies.get<CompareMonthsUseCase>();
  });
  tearDown(() => dependencies.dispose());

  test('defaults to the previous month up to the same day', () {
    final comparison = compare(isToDate: true);

    expect(comparison.referenceMonth, DateTime(2026, 9));
    expect(comparison.today, DateTime(2026, 10, 15));
    expect(comparison.currentTotal, 80);
    expect(comparison.referenceTotal, 80);
    expect(comparison.ratio, 0);
    expect(comparison.hasReferenceData, isTrue);
    expect(comparison.moves, const [
      CategoryMove(categoryKey: 'ali', current: 50, previous: 80),
      CategoryMove(categoryKey: 'loi', current: 30, previous: 0),
    ]);
    expect(comparison.biggestDrop?.categoryKey, 'ali');
    expect(comparison.biggestRise?.categoryKey, 'loi');
    expect(comparison.largestDelta, 30);
  });

  test('the whole reference month counts every expense of that month', () {
    final comparison = compare(isToDate: false);

    expect(comparison.referenceTotal, 120);
    expect(comparison.difference, -40);
    expect(comparison.ratio, closeTo(-1 / 3, 1e-9));
    expect(comparison.biggestDrop?.categoryKey, 'tra');
  });

  test('a month without expenses has no reference data and no ratio', () {
    final comparison = compare(referenceMonth: DateTime(2026, 8, 12), isToDate: true);

    expect(comparison.referenceMonth, DateTime(2026, 8));
    expect(comparison.hasReferenceData, isFalse);
    expect(comparison.ratio, isNull);
    expect(comparison.biggestDrop, isNull);
    expect(comparison.biggestRise?.categoryKey, 'ali');
  });
}
