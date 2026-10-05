import 'package:depenses/layers/functional/Recurrences/domain/entities/frequency.dart';
import 'package:depenses/layers/functional/Recurrences/domain/entities/recurrence.dart';
import 'package:depenses/layers/functional/Simulations/domain/use_cases/hypothesize_recurrence_change_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('a recurrence change starts unchanged and kept', () {
    final recurrence = Recurrence(
      id: 'gym',
      name: 'Salle',
      amount: 25,
      categoryKey: 'san',
      frequency: Frequency.week,
      start: DateTime(2026, 1, 5),
    );

    final hypothesis = HypothesizeRecurrenceChangeUseCase()(recurrence);

    expect(hypothesis.recurrenceId, 'gym');
    expect(hypothesis.name, 'Salle');
    expect(hypothesis.categoryKey, 'san');
    expect(hypothesis.frequency, Frequency.week);
    expect(hypothesis.oldAmount, 25);
    expect(hypothesis.newAmount, 25);
    expect(hypothesis.isKept, isTrue);
    expect(hypothesis.monthlyDelta, 0);
  });
}
