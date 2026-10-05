import 'package:depenses/layers/functional/Account/presentation/l10n/account_locale.dart';
import 'package:depenses/layers/functional/Forecast/presentation/l10n/forecast_compare_locale.dart';
import 'package:depenses/layers/functional/Forecast/presentation/l10n/forecast_locale.dart';
import 'package:depenses/layers/functional/Savings/presentation/l10n/savings_locale.dart';
import 'package:depenses/layers/technical/Localization/localization_locale.dart';
import 'package:depenses/layers/technical/Localization/prepare_formatting.dart';
import 'package:depenses/layers/technical/Theme/app_palette.dart';
import 'package:depenses/layers/technical/Theme/app_style.dart';
import 'package:depenses/layers/technical/Theme/app_theme.dart';
import 'package:depenses/layers/technical/Theme/app_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> prepareTestLocalization() async {
  SharedPreferences.setMockInitialValues({});
  final localization = FlutterLocalization.instance;
  await localization.ensureInitialized();
  localization.init(
    mapLocales: const [
      MapLocale('fr', {
        ...LocalizationLocale.fr,
        ...ForecastLocale.fr,
        ...ForecastCompareLocale.fr,
        ...AccountLocale.fr,
        ...SavingsLocale.fr,
      }, countryCode: 'FR'),
    ],
    initLanguageCode: 'fr',
  );
  await prepareFormatting('fr_FR');
}

Widget testApp(AppStyle style, Widget home) {
  final localization = FlutterLocalization.instance;
  return MaterialApp(
    theme: AppTheme.build(AppTokens.resolve(style: style, palette: AppPalette.menthe, isDark: false)),
    supportedLocales: localization.supportedLocales,
    localizationsDelegates: localization.localizationsDelegates,
    home: home,
  );
}
