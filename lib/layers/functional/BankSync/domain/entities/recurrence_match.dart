import 'package:depenses/layers/functional/Recurrences/domain/entities/recurrence.dart';
import 'package:depenses/layers/technical/Calendar/calendar_day.dart';
import 'package:equatable/equatable.dart';

class RecurrenceMatch extends Equatable {
  const RecurrenceMatch({required this.recurrence, required this.occurrence, required this.distance});

  final Recurrence recurrence;
  final DateTime occurrence;
  final double distance;

  Recurrence? get generatedThroughOccurrence {
    final lastGenerated = recurrence.lastGeneratedOn;
    if (lastGenerated != null && !lastGenerated.isBefore(occurrence)) return null;
    final from = lastGenerated == null ? recurrence.start : lastGenerated.nextDay;
    if (recurrence.occurrences(from, occurrence.previousDay).isNotEmpty) return null;
    return recurrence.copyWith(lastGeneratedOn: occurrence);
  }

  @override
  List<Object?> get props => [recurrence, occurrence, distance];
}
