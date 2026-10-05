import 'package:depenses/layers/functional/Recurrences/domain/use_cases/get_upcoming_occurrences_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';

Map<String, dynamic> _rent({required String lastGenerated}) => {
  'id': 'rent',
  'name': 'Loyer',
  'amount': 800,
  'cat': 'log',
  'freq': 'month',
  'start': '2026-01-17',
  'labels': <String>[],
  'lastGen': lastGenerated,
};

void main() {
  test('an occurrence already paid early by the bank is not listed as upcoming', () async {
    final dependencies = TestDependencies(
      today: DateTime(2026, 10, 15),
      data: {
        'recs': [_rent(lastGenerated: '2026-10-17')],
      },
    );
    addTearDown(dependencies.dispose);

    final upcoming = dependencies.get<GetUpcomingOccurrencesUseCase>()(DateTime(2026, 10, 16), DateTime(2026, 11, 30));

    expect(upcoming.map((o) => o.date), [DateTime(2026, 11, 17)]);
  });

  test('occurrences after the last generated day stay upcoming', () async {
    final dependencies = TestDependencies(
      today: DateTime(2026, 10, 15),
      data: {
        'recs': [_rent(lastGenerated: '2026-10-15')],
      },
    );
    addTearDown(dependencies.dispose);

    final upcoming = dependencies.get<GetUpcomingOccurrencesUseCase>()(DateTime(2026, 10, 16), DateTime(2026, 10, 31));

    expect(upcoming.map((o) => o.date), [DateTime(2026, 10, 17)]);
  });
}
