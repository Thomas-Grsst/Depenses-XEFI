import 'package:depenses/layers/functional/Categories/domain/entities/category.dart';
import 'package:depenses/layers/functional/Recurrences/domain/entities/frequency.dart';
import 'package:depenses/layers/functional/Recurrences/domain/entities/recurrence.dart';
import 'package:depenses/layers/technical/Calendar/clock.dart';

class PreviewNextOccurrenceUseCase {
  PreviewNextOccurrenceUseCase(this._clock);

  final Clock _clock;

  DateTime? call({required Frequency frequency, required DateTime start}) {
    final today = _clock.today();
    if (start.isAfter(today)) return start;
    final schedule = Recurrence(
      id: '',
      name: '',
      amount: 0,
      categoryKey: Category.otherKey,
      frequency: frequency,
      start: start,
    );
    return schedule.nextAfter(today);
  }
}
