import '../entities/occurrence.dart';
import '../entities/recurrence.dart';
import '../gateways/recurrence_gateway.dart';

class GetUpcomingOccurrencesUseCase {
  GetUpcomingOccurrencesUseCase(this._recurrences);

  final RecurrenceGateway _recurrences;

  List<Occurrence> call(DateTime from, DateTime to) {
    final occurrences = [
      for (final recurrence in _recurrences.all())
        for (final date in recurrence.occurrences(from, to))
          if (!_isAlreadyCovered(recurrence, date)) Occurrence(date, recurrence),
    ]..sort((a, b) => a.date.compareTo(b.date));
    return occurrences;
  }

  static bool _isAlreadyCovered(Recurrence recurrence, DateTime date) {
    final lastGenerated = recurrence.lastGeneratedOn;
    return lastGenerated != null && !date.isAfter(lastGenerated);
  }
}
