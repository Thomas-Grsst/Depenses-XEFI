import 'package:depenses/app/app_router.dart';
import 'package:depenses/layers/functional/BankSync/presentation/l10n/bank_import_locale.dart';
import 'package:depenses/layers/functional/BankSync/presentation/l10n/bank_sync_locale.dart';
import 'package:depenses/layers/technical/Localization/localization_locale.dart';
import 'package:depenses/layers/technical/Localization/prepare_formatting.dart';
import 'package:depenses/layers/technical/Theme/app_palette.dart';
import 'package:depenses/layers/technical/Theme/app_style.dart';
import 'package:depenses/layers/technical/Theme/app_theme.dart';
import 'package:depenses/layers/technical/Theme/app_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> prepareBankSyncLocalization() async {
  SharedPreferences.setMockInitialValues({});
  final localization = FlutterLocalization.instance;
  await localization.ensureInitialized();
  localization.init(
    mapLocales: const [
      MapLocale('fr', {...LocalizationLocale.fr, ...BankSyncLocale.fr, ...BankImportLocale.fr}, countryCode: 'FR'),
    ],
    initLanguageCode: 'fr',
  );
  await prepareFormatting('fr_FR');
}

Widget bankSyncTestApp(AppStyle style, Widget home) {
  final localization = FlutterLocalization.instance;
  final tokens = AppTokens.resolve(style: style, palette: AppPalette.menthe, isDark: false);
  return MaterialApp(
    theme: AppTheme.build(tokens),
    supportedLocales: localization.supportedLocales,
    localizationsDelegates: localization.localizationsDelegates,
    onGenerateRoute: AppRouter(tokens).onGenerateRoute,
    home: home,
  );
}
