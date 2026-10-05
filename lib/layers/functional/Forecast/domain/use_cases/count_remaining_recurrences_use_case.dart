import '../entities/month_stats.dart';
import '../entities/recurrence_tally.dart';

class CountRemainingRecurrencesUseCase {
  const CountRemainingRecurrencesUseCase();

  List<RecurrenceTally> call(MonthStats stats) {
    final counts = <String, int>{};
    for (final occurrence in stats.remainingOccurrences) {
      counts.update(occurrence.recurrence.name, (count) => count + 1, ifAbsent: () => 1);
    }
    return [for (final entry in counts.entries) RecurrenceTally(name: entry.key, count: entry.value)];
  }
}
