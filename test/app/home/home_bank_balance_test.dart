import 'package:depenses/app/app_localization.dart';
import 'package:depenses/app/home/cubit/home_lists_cubit.dart';
import 'package:depenses/app/home/home_dependencies.dart';
import 'package:depenses/app/home/home_page.dart';
import 'package:depenses/layers/functional/Account/domain/use_cases/get_balance_use_case.dart';
import 'package:depenses/layers/functional/Account/presentation/cubit/account_summary_cubit.dart';
import 'package:depenses/layers/functional/BankSync/domain/gateways/linked_account_gateway.dart';
import 'package:depenses/layers/functional/BankSync/presentation/cubit/bank_balance_cubit.dart';
import 'package:depenses/layers/functional/Forecast/presentation/cubit/forecast_summary_cubit.dart';
import 'package:depenses/layers/functional/Savings/presentation/cubit/savings_summary_cubit.dart';
import 'package:depenses/layers/technical/Theme/app_palette.dart';
import 'package:depenses/layers/technical/Theme/app_style.dart';
import 'package:depenses/layers/technical/Theme/app_theme.dart';
import 'package:depenses/layers/technical/Theme/app_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../layers/functional/BankSync/support/bank_link_fakes.dart';
import '../../support/test_dependencies.dart';

void main() {
  late TestDependencies dependencies;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await prepareAppLocalization();
  });
  setUp(() {
    dependencies = TestDependencies(
      today: DateTime(2026, 10, 15),
      data: {
        'settings': {'balance': 1237, 'balanceDate': '2026-10-15'},
      },
    );
    registerHomeDependencies(dependencies.getIt);
    GetIt.I
      ..registerFactory<ForecastSummaryCubit>(dependencies.get)
      ..registerFactory<AccountSummaryCubit>(dependencies.get)
      ..registerFactory<BankBalanceCubit>(dependencies.get)
      ..registerFactory<SavingsSummaryCubit>(dependencies.get)
      ..registerFactory<HomeListsCubit>(dependencies.get);
  });
  tearDown(() async {
    await GetIt.I.reset();
    await dependencies.dispose();
  });

  Future<void> openHome(WidgetTester tester, AppStyle style) async {
    final localization = FlutterLocalization.instance;
    final tokens = AppTokens.resolve(style: style, palette: AppPalette.menthe, isDark: false);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.build(tokens),
        supportedLocales: localization.supportedLocales,
        localizationsDelegates: localization.localizationsDelegates,
        home: const Scaffold(body: HomePage()),
      ),
    );
    await tester.pump();
  }

  for (final style in AppStyle.values) {
    testWidgets('the home offers the bank balance and uses it on demand in ${style.name}', (tester) async {
      await dependencies.get<LinkedAccountGateway>().save(linkedAccount(lastBankBalance: 1180.50));
      await openHome(tester, style);

      expect(find.textContaining(RegExp(r'Solde bancaire : 1\s180,50\s€'), findRichText: true), findsOneWidget);
      expect(dependencies.get<GetBalanceUseCase>()(), 1237);

      await tester.tap(find.text('Utiliser ce solde'));
      await tester.pump();
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(dependencies.get<GetBalanceUseCase>()(), 1180.50);
      expect(find.text('Utiliser ce solde'), findsNothing);
    });
  }

  testWidgets('the home shows no offer when the bank agrees with the app', (tester) async {
    await dependencies.get<LinkedAccountGateway>().save(linkedAccount(lastBankBalance: 1237));
    await openHome(tester, AppStyle.menthe);

    expect(find.text('Utiliser ce solde'), findsNothing);
  });
}
