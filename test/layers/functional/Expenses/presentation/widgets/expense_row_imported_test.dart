import 'package:depenses/layers/functional/Categories/domain/entities/default_categories.dart';
import 'package:depenses/layers/functional/Categories/domain/entities/merchant_look.dart';
import 'package:depenses/layers/functional/Expenses/domain/entities/described_expense.dart';
import 'package:depenses/layers/functional/Expenses/domain/entities/expense.dart';
import 'package:depenses/layers/functional/Expenses/domain/entities/expense_origin.dart';
import 'package:depenses/layers/functional/Expenses/presentation/l10n/expenses_locale.dart';
import 'package:depenses/layers/functional/Expenses/presentation/widgets/expense_row.dart';
import 'package:depenses/layers/technical/Localization/localization_locale.dart';
import 'package:depenses/layers/technical/Localization/prepare_formatting.dart';
import 'package:depenses/layers/technical/Theme/app_palette.dart';
import 'package:depenses/layers/technical/Theme/app_style.dart';
import 'package:depenses/layers/technical/Theme/app_theme.dart';
import 'package:depenses/layers/technical/Theme/app_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

DescribedExpense _described(ExpenseOrigin origin) => DescribedExpense(
  expense: Expense(
    id: 'e',
    name: 'Carrefour',
    amount: 12.4,
    date: DateTime(2026, 10, 3),
    categoryKey: 'ali',
    origin: origin,
  ),
  category: defaultCategories[1],
  look: const MerchantLook.icon('cart'),
);

Widget _app(AppStyle style, Widget child) {
  final localization = FlutterLocalization.instance;
  return MaterialApp(
    theme: AppTheme.build(AppTokens.resolve(style: style, palette: AppPalette.menthe, isDark: false)),
    supportedLocales: localization.supportedLocales,
    localizationsDelegates: localization.localizationsDelegates,
    home: Scaffold(body: child),
  );
}

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    final localization = FlutterLocalization.instance;
    await localization.ensureInitialized();
    localization.init(
      mapLocales: const [
        MapLocale('fr', {...LocalizationLocale.fr, ...ExpensesLocale.fr}, countryCode: 'FR'),
      ],
      initLanguageCode: 'fr',
    );
    await prepareFormatting('fr_FR');
  });

  for (final style in AppStyle.values) {
    testWidgets('an imported expense shows the imported badge in ${style.name}', (tester) async {
      await tester.pumpWidget(_app(style, ExpenseRow(_described(ExpenseOrigin.bank))));
      await tester.pumpAndSettle();

      expect(find.text('Importée'), findsOneWidget);
    });

    testWidgets('a manual expense has no imported badge in ${style.name}', (tester) async {
      await tester.pumpWidget(_app(style, ExpenseRow(_described(ExpenseOrigin.manual))));
      await tester.pumpAndSettle();

      expect(find.text('Importée'), findsNothing);
      expect(find.text('Carrefour'), findsOneWidget);
    });
  }
}
