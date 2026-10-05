import 'package:flutter/widgets.dart';
import 'package:flutter_localization/flutter_localization.dart';

import 'date_labels.dart';
import 'date_words.dart';
import 'localization_locale.dart';
import 'money_format.dart';

extension FormattingContext on BuildContext {
  String get localeName => Localizations.localeOf(this).toString();

  MoneyFormat get money => MoneyFormat(localeName);

  DateLabels get dates => DateLabels(
    localeName,
    DateWords(
      today: LocalizationLocale.today.getString(this),
      yesterday: LocalizationLocale.yesterday.getString(this),
      tomorrow: LocalizationLocale.tomorrow.getString(this),
      firstDayOfMonth: LocalizationLocale.firstDayOfMonth.getString(this),
      yesterdayWith: (date) => formatString(LocalizationLocale.yesterdayWithDate.getString(this), [date]),
    ),
  );

  String tr(String key) => key.getString(this);

  String trWith(String key, List<Object> args) => formatString(key.getString(this), args);
}
