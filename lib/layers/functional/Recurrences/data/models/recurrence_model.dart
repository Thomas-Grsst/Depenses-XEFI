import 'package:depenses/layers/technical/Storage/json_reading.dart';

import '../../domain/entities/frequency.dart';
import '../../domain/entities/recurrence.dart';

abstract final class RecurrenceModel {
  static Recurrence fromJson(Map<String, dynamic> json) => Recurrence(
    id: json.text('id'),
    name: json.text('name'),
    amount: json.decimal('amount'),
    categoryKey: json.text('cat'),
    frequency: Frequency.fromStorageKey(json.text('freq')),
    start: json.day('start'),
    labels: json.strings('labels'),
    lastGeneratedOn: json.optionalDay('lastGen'),
  );

  static Map<String, dynamic> toJson(Recurrence recurrence) {
    final lastGenerated = recurrence.lastGeneratedOn;
    return {
      'id': recurrence.id,
      'name': recurrence.name,
      'amount': recurrence.amount,
      'cat': recurrence.categoryKey,
      'freq': recurrence.frequency.storageKey,
      'start': encodeDay(recurrence.start),
      'labels': recurrence.labels,
      'lastGen': lastGenerated == null ? null : encodeDay(lastGenerated),
    };
  }
}
