import 'package:depenses/layers/technical/Calendar/calendar_day.dart';
import 'package:depenses/layers/technical/Calendar/clock.dart';

import '../entities/occurrence.dart';
import 'get_upcoming_occurrences_use_case.dart';

class GetNextOccurrencesUseCase {
  GetNextOccurrencesUseCase(this._upcoming, this._clock);

  final GetUpcomingOccurrencesUseCase _upcoming;
  final Clock _clock;

  List<Occurrence> call(int count) {
    final today = _clock.today();
    final horizon = DateTime(today.year + 1, today.month, today.day);
    return _upcoming(today.nextDay, horizon).take(count).toList();
  }
}
