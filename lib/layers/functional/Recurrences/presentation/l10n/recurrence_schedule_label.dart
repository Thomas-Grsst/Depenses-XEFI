import 'package:depenses/layers/functional/Recurrences/domain/entities/frequency.dart';
import 'package:depenses/layers/functional/Recurrences/domain/entities/recurrence.dart';
import 'package:depenses/layers/technical/Localization/schedule_labels.dart';
import 'package:flutter/widgets.dart';

extension RecurrenceScheduleLabel on BuildContext {
  String scheduleOf(Recurrence recurrence) => switch (recurrence.frequency) {
    Frequency.week => everyWeekOn(recurrence.start),
    Frequency.year => everyYearOn(recurrence.start),
    Frequency.month => everyMonthOn(recurrence.start),
  };
}
