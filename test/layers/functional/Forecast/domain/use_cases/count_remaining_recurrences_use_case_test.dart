import 'package:depenses/layers/functional/Forecast/domain/entities/recurrence_tally.dart';
import 'package:depenses/layers/functional/Forecast/domain/use_cases/compute_month_stats_use_case.dart';
import 'package:depenses/layers/functional/Forecast/domain/use_cases/count_remaining_recurrences_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';
import '../../forecast_seed.dart';

void main() {
  late TestDependencies dependencies;

  tearDown(() => dependencies.dispose());

  List<RecurrenceTally> countFor(List<Map<String, dynamic>> recurrences) {
    dependencies = TestDependencies(today: DateTime(2026, 10, 15), data: {'recs': recurrences});
    return dependencies.get<CountRemainingRecurrencesUseCase>()(dependencies.get<ComputeMonthStatsUseCase>()());
  }

  test('groups the occurrences left this month by recurrence name, in date order', () {
    final tallies = countFor([
      forecastRecurrence('r1', 'Sport', 12, '2026-10-01', frequency: 'week'),
      forecastRecurrence('r2', 'Électricité', 60, '2026-09-20'),
    ]);

    expect(tallies, const [RecurrenceTally(name: 'Électricité', count: 1), RecurrenceTally(name: 'Sport', count: 2)]);
    expect(tallies.last.isRepeated, isTrue);
    expect(tallies.first.isRepeated, isFalse);
  });

  test('nothing left this month gives an empty list', () {
    expect(countFor([forecastRecurrence('r1', 'Loyer', 800, '2026-09-05')]), isEmpty);
  });
}
