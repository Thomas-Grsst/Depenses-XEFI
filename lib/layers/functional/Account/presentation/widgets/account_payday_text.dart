import 'package:depenses/layers/technical/Calendar/calendar_day.dart';
import 'package:depenses/layers/technical/Localization/capitalize.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Localization/localization_locale.dart';
import 'package:flutter/widgets.dart';

import '../../domain/entities/account_summary.dart';
import '../l10n/account_locale.dart';

const _daysShownAsWeekday = 7;

String? accountPaydayText(BuildContext context, AccountSummary summary, DateTime today) {
  final payday = summary.nextPayday;
  if (payday == null) return null;
  return context.trWith(AccountLocale.paydayAndIncome, [
    _relativePayday(context, payday, today).toLowerCase(),
    context.money.withSign(summary.income, context.money.wholeEuros),
  ]);
}

String _relativePayday(BuildContext context, DateTime payday, DateTime today) {
  if (payday.isSameDay(today.nextDay)) return context.tr(LocalizationLocale.tomorrow);
  if (payday.difference(today).inDays < _daysShownAsWeekday) {
    return context.trWith(AccountLocale.weekdayAndDay, [capitalize(context.dates.weekday(payday)), '${payday.day}']);
  }
  return context.dates.dayAndMonth(payday);
}
