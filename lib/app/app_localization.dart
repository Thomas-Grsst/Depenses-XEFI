import 'package:depenses/layers/functional/Account/presentation/l10n/account_locale.dart';
import 'package:depenses/layers/functional/BankSync/presentation/l10n/bank_import_locale.dart';
import 'package:depenses/layers/functional/BankSync/presentation/l10n/bank_sync_locale.dart';
import 'package:depenses/layers/functional/Budget/presentation/l10n/budget_locale.dart';
import 'package:depenses/layers/functional/Categories/presentation/l10n/categories_locale.dart';
import 'package:depenses/layers/functional/Expenses/presentation/l10n/expenses_locale.dart';
import 'package:depenses/layers/functional/Forecast/presentation/l10n/forecast_compare_locale.dart';
import 'package:depenses/layers/functional/Forecast/presentation/l10n/forecast_locale.dart';
import 'package:depenses/layers/functional/Onboarding/presentation/l10n/onboarding_locale.dart';
import 'package:depenses/layers/functional/Profile/presentation/l10n/profile_locale.dart';
import 'package:depenses/layers/functional/Recurrences/presentation/l10n/recurrences_locale.dart';
import 'package:depenses/layers/functional/Savings/presentation/l10n/savings_locale.dart';
import 'package:depenses/layers/functional/Simulations/presentation/l10n/simulations_locale.dart';
import 'package:depenses/layers/technical/Localization/localization_locale.dart';
import 'package:depenses/layers/technical/Localization/prepare_formatting.dart';
import 'package:flutter_localization/flutter_localization.dart';

import 'home/l10n/home_locale.dart';
import 'l10n/app_locale.dart';

const _languageCode = 'fr';
const _countryCode = 'FR';

const Map<String, dynamic> frenchTranslations = {
  ...LocalizationLocale.fr,
  ...AppLocale.fr,
  ...HomeLocale.fr,
  ...AccountLocale.fr,
  ...BankSyncLocale.fr,
  ...BankImportLocale.fr,
  ...BudgetLocale.fr,
  ...CategoriesLocale.fr,
  ...ExpensesLocale.fr,
  ...ForecastLocale.fr,
  ...ForecastCompareLocale.fr,
  ...OnboardingLocale.fr,
  ...ProfileLocale.fr,
  ...RecurrencesLocale.fr,
  ...SavingsLocale.fr,
  ...SimulationsLocale.fr,
};

Future<void> prepareAppLocalization() async {
  final localization = FlutterLocalization.instance;
  await localization.ensureInitialized();
  localization.init(
    mapLocales: const [MapLocale(_languageCode, frenchTranslations, countryCode: _countryCode)],
    initLanguageCode: _languageCode,
  );
  await prepareFormatting('${_languageCode}_$_countryCode');
}
