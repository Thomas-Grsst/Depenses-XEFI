import 'package:depenses/layers/functional/Account/domain/use_cases/get_balance_use_case.dart';
import 'package:depenses/layers/functional/BankSync/domain/gateways/linked_account_gateway.dart';
import 'package:depenses/layers/functional/BankSync/presentation/cubit/bank_balance_cubit.dart';
import 'package:depenses/layers/functional/BankSync/presentation/widgets/bank_balance_banner.dart';
import 'package:depenses/layers/technical/Theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';
import '../../support/bank_link_fakes.dart';
import '../views/bank_sync_test_app.dart';

void main() {
  late TestDependencies dependencies;

  setUpAll(prepareBankSyncLocalization);
  setUp(() {
    dependencies = TestDependencies(
      today: DateTime(2026, 10, 15),
      data: {
        'settings': {'balance': 1237, 'balanceDate': '2026-10-15'},
      },
    );
  });
  tearDown(() => dependencies.dispose());

  Future<void> show(WidgetTester tester, AppStyle style) async {
    final banner = BlocProvider(create: (_) => dependencies.get<BankBalanceCubit>(), child: const BankBalanceBanner());
    await tester.pumpWidget(bankSyncTestApp(style, Scaffold(body: banner)));
    await tester.pump();
  }

  Future<void> bankSays(double? balance) =>
      dependencies.get<LinkedAccountGateway>().save(linkedAccount(lastBankBalance: balance));

  testWidgets('without bank balance nothing is shown', (tester) async {
    await bankSays(null);
    await show(tester, AppStyle.menthe);

    expect(find.text('Utiliser ce solde'), findsNothing);
  });

  testWidgets('a gap of one euro or less is not offered', (tester) async {
    await bankSays(1236.50);
    await show(tester, AppStyle.menthe);

    expect(find.text('Utiliser ce solde'), findsNothing);
  });

  for (final style in AppStyle.values) {
    testWidgets('a gap offers the bank balance and aligns on tap in ${style.name}', (tester) async {
      await bankSays(1180.50);
      await show(tester, style);

      expect(find.textContaining(RegExp(r'Solde bancaire : 1\s180,50\s€'), findRichText: true), findsOneWidget);

      await tester.tap(find.text('Utiliser ce solde'));
      await tester.pump();
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(dependencies.get<GetBalanceUseCase>()(), 1180.50);
      expect(find.text('Utiliser ce solde'), findsNothing);
    });
  }
}
