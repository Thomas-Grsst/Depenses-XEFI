import 'package:depenses/layers/functional/Account/domain/gateways/account_gateway.dart';
import 'package:depenses/layers/functional/Account/presentation/cubit/account_cubit.dart';
import 'package:depenses/layers/functional/Account/presentation/cubit/account_summary_cubit.dart';
import 'package:depenses/layers/functional/Account/presentation/views/account_page.dart';
import 'package:depenses/layers/functional/Account/presentation/widgets/account_balance_card.dart';
import 'package:depenses/layers/functional/Account/presentation/widgets/account_balance_prompt.dart';
import 'package:depenses/layers/functional/Account/presentation/widgets/account_end_of_month_breakdown.dart';
import 'package:depenses/layers/technical/Theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import '../../../../../support/test_dependencies.dart';
import '../../../Forecast/forecast_test_app.dart';

void main() {
  late TestDependencies dependencies;

  setUpAll(prepareTestLocalization);
  setUp(() {
    dependencies = TestDependencies(
      today: DateTime(2026, 10, 15),
      data: {
        'settings': {'income': 2000, 'payDay': 16, 'balance': 900, 'balanceDate': '2026-10-15'},
        'expenses': [
          {'id': 'a', 'name': 'Courses', 'amount': 42.5, 'date': '2026-10-02', 'cat': 'ali', 'labels': <String>[]},
        ],
      },
    );
    GetIt.I.registerFactory(() => dependencies.get<AccountCubit>());
  });
  tearDown(() async {
    await GetIt.I.reset();
    await dependencies.dispose();
  });

  for (final style in AppStyle.values) {
    testWidgets('the account page saves the form and closes in ${style.name}', (tester) async {
      await tester.pumpWidget(
        testApp(
          style,
          Builder(
            builder: (context) => TextButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const AccountPage())),
              child: const Text('open'),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.byType(AccountEndOfMonthBreakdown), findsOneWidget);

      await tester.tap(find.text('+'));
      await tester.pump();
      expect(find.text('17'), findsOneWidget);
      await tester.enterText(find.byType(TextField).first, '');
      await tester.tap(find.text('Enregistrer'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('open'), findsOneWidget);
      final settings = dependencies.get<AccountGateway>().get();
      expect(settings.payDay, 17);
      expect(settings.hasBalance, isFalse);
    });

    testWidgets('the balance card opens the end-of-month detail in ${style.name}', (tester) async {
      final cubit = dependencies.get<AccountSummaryCubit>();
      addTearDown(cubit.close);
      final state = cubit.state;
      await tester.pumpWidget(
        testApp(
          style,
          Scaffold(
            body: AccountBalanceCard(summary: state.summary, today: state.today!),
          ),
        ),
      );
      await tester.pump();
      expect(find.textContaining('Salaire demain', findRichText: true), findsOneWidget);

      await tester.tap(find.byType(AccountBalanceCard));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Fin de octobre'), findsOneWidget);
      expect(find.byType(AccountEndOfMonthBreakdown), findsOneWidget);
    });

    testWidgets('without balance the card invites to enter one in ${style.name}', (tester) async {
      await dependencies.get<AccountGateway>().save(
        dependencies.get<AccountGateway>().get().withBalance(null, null, const []),
      );
      final cubit = dependencies.get<AccountSummaryCubit>();
      addTearDown(cubit.close);
      await tester.pumpWidget(
        testApp(
          style,
          Scaffold(
            body: AccountBalanceCard(summary: cubit.state.summary, today: cubit.state.today!),
          ),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.byType(AccountBalancePrompt), findsOneWidget);
    });
  }
}
