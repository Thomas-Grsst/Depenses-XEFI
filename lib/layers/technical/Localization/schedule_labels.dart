import 'package:flutter/widgets.dart';
import 'package:flutter_localization/flutter_localization.dart';

import 'formatting_context.dart';
import 'localization_locale.dart';

extension ScheduleLabels on BuildContext {
  String everyWeekOn(DateTime start) =>
      formatString(LocalizationLocale.everyWeekOn.getString(this), [dates.weekday(start)]);

  String everyMonthOn(DateTime start) =>
      formatString(LocalizationLocale.everyMonthOn.getString(this), ['${start.day}']);

  String everyYearOn(DateTime start) =>
      formatString(LocalizationLocale.everyYearOn.getString(this), [dates.dayAndMonth(start)]);
}
