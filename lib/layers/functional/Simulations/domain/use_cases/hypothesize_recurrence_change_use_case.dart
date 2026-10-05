import 'package:depenses/layers/functional/Recurrences/domain/entities/recurrence.dart';

import '../entities/hypothesis.dart';

class HypothesizeRecurrenceChangeUseCase {
  Hypothesis call(Recurrence recurrence) => Hypothesis(
    recurrenceId: recurrence.id,
    name: recurrence.name,
    categoryKey: recurrence.categoryKey,
    frequency: recurrence.frequency,
    oldAmount: recurrence.amount,
    newAmount: recurrence.amount,
  );
}
