import 'package:depenses/layers/functional/Simulations/domain/use_cases/get_simulable_recurrences_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';
import '../../simulations_fixtures.dart';

void main() {
  late TestDependencies dependencies;

  setUp(() {
    dependencies = TestDependencies(
      today: simulationsToday,
      data: {
        'recs': [
          recurrenceJson('phone', 'Forfait', 50, 'month'),
          recurrenceJson('lunch', 'Cantine', 20, 'week'),
          recurrenceJson('rent', 'Loyer', 700, 'month'),
        ],
      },
    );
  });
  tearDown(() => dependencies.dispose());

  test('lists the recurrences not yet simulated, biggest monthly cost first', () {
    final recurrences = dependencies.get<GetSimulableRecurrencesUseCase>()({'rent'});

    expect([for (final r in recurrences) r.id], ['lunch', 'phone']);
  });
}
