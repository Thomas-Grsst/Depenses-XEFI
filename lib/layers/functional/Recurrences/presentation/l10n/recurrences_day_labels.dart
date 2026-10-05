import 'package:depenses/layers/technical/Localization/capitalize.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Localization/localization_locale.dart';
import 'package:flutter/widgets.dart';

import '../cubit/day_timing.dart';
import 'recurrences_locale.dart';

final _referenceMonday = DateTime(2024, 1, 1);

extension RecurrencesDayLabels on BuildContext {
  String selectedDayTitle(DateTime? day, {required bool isShort}) {
    if (day == null) return tr(RecurrencesLocale.pickDay);
    if (isShort) return trWith(RecurrencesLocale.selectedDayShort, [dates.weekday(day), day.day]).toUpperCase();
    return capitalize(trWith(RecurrencesLocale.selectedDay, [dates.weekday(day), day.day, dates.monthName(day)]));
  }

  String dayTimingLabel(DayTiming? timing) => switch (timing) {
    null => '',
    DayTiming.today => tr(LocalizationLocale.today),
    DayTiming.past => tr(RecurrencesLocale.paid),
    DayTiming.future => tr(RecurrencesLocale.planned),
  };

  List<String> weekdayHeaders({required bool isShort}) => [
    for (var offset = 0; offset < DateTime.daysPerWeek; offset++)
      _weekdayHeader(DateTime(_referenceMonday.year, _referenceMonday.month, _referenceMonday.day + offset), isShort),
  ];

  String _weekdayHeader(DateTime day, bool isShort) {
    final abbreviation = dates.shortWeekday(day).replaceAll('.', '').toUpperCase();
    return isShort || abbreviation.isEmpty ? abbreviation : abbreviation[0];
  }
}
