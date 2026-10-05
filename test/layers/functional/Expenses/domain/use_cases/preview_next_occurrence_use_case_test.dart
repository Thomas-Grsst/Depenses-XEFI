import 'package:depenses/layers/functional/Expenses/domain/use_cases/preview_next_occurrence_use_case.dart';
import 'package:depenses/layers/functional/Recurrences/domain/entities/frequency.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';

void main() {
  late TestDependencies dependencies;
  late PreviewNextOccurrenceUseCase preview;

  setUp(() {
    dependencies = TestDependencies(today: DateTime(2026, 10, 15));
    preview = dependencies.get<PreviewNextOccurrenceUseCase>();
  });
  tearDown(() => dependencies.dispose());

  test('returns the start when it is in the future', () {
    expect(preview(frequency: Frequency.month, start: DateTime(2026, 11, 2)), DateTime(2026, 11, 2));
  });

  test('returns the next occurrence after today otherwise', () {
    expect(preview(frequency: Frequency.month, start: DateTime(2026, 1, 15)), DateTime(2026, 11, 15));
    expect(preview(frequency: Frequency.week, start: DateTime(2026, 10, 1)), DateTime(2026, 10, 22));
    expect(preview(frequency: Frequency.year, start: DateTime(2020, 3, 1)), DateTime(2027, 3, 1));
  });
}
