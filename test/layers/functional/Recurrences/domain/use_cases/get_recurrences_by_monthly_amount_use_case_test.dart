import 'package:depenses/layers/functional/Recurrences/domain/use_cases/get_recurrences_by_monthly_amount_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';

Map<String, dynamic> _recurrence(String id, double amount, String frequency) => {
  'id': id,
  'name': id,
  'amount': amount,
  'cat': 'log',
  'freq': frequency,
  'start': '2026-01-05',
  'labels': <String>[],
  'lastGen': '2026-10-15',
};

void main() {
  late TestDependencies dependencies;

  setUp(() {
    dependencies = TestDependencies(
      data: {
        'recs': [
          _recurrence('yearly', 600, 'year'),
          _recurrence('weekly', 20, 'week'),
          _recurrence('monthly', 80, 'month'),
        ],
      },
    );
  });
  tearDown(() => dependencies.dispose());

  test('recurrences are sorted by their monthly weight, largest first', () {
    final recurrences = dependencies.get<GetRecurrencesByMonthlyAmountUseCase>()();

    expect([for (final r in recurrences) r.id], ['weekly', 'monthly', 'yearly']);
  });
}
