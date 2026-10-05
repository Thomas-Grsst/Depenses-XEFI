import 'package:depenses/layers/technical/Calendar/calendar_day.dart';
import 'package:depenses/layers/technical/Localization/capitalize.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Localization/localization_locale.dart';
import 'package:flutter/widgets.dart';

import 'recurrences_locale.dart';

const _daysWithinWeek = 7;

extension RelativeDayLong on BuildContext {
  String relativeDayLong(DateTime date, {required DateTime today}) {
    if (date.isSameDay(today.nextDay)) return tr(LocalizationLocale.tomorrow);
    if (date.difference(today).inDays < _daysWithinWeek) {
      return capitalize(trWith(RecurrencesLocale.weekdayAndDay, [dates.weekday(date), date.day]));
    }
    return dates.dayAndMonth(date);
  }
}
