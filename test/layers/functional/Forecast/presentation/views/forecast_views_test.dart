import 'package:depenses/layers/functional/Forecast/presentation/cubit/compare_cubit.dart';
import 'package:depenses/layers/functional/Forecast/presentation/cubit/forecast_cubit.dart';
import 'package:depenses/layers/functional/Forecast/presentation/cubit/forecast_summary_cubit.dart';
import 'package:depenses/layers/functional/Forecast/presentation/views/compare_page.dart';
import 'package:depenses/layers/functional/Forecast/presentation/views/forecast_page.dart';
import 'package:depenses/layers/functional/Forecast/presentation/widgets/compare_insight.dart';
import 'package:depenses/layers/functional/Forecast/presentation/widgets/compare_move_row.dart';
import 'package:depenses/layers/functional/Forecast/presentation/widgets/forecast_alert_bell.dart';
import 'package:depenses/layers/functional/Forecast/presentation/widgets/forecast_alert_callout.dart';
import 'package:depenses/layers/functional/Forecast/presentation/widgets/forecast_alert_list.dart';
import 'package:depenses/layers/functional/Forecast/presentation/widgets/forecast_budget_meter.dart';
import 'package:depenses/layers/functional/Forecast/presentation/widgets/forecast_moves_card.dart';
import 'package:depenses/layers/functional/Forecast/presentation/widgets/forecast_sparkline_card.dart';
import 'package:depenses/layers/functional/Forecast/presentation/widgets/forecast_spent_hero.dart';
import 'package:depenses/layers/functional/Forecast/presentation/widgets/forecast_spent_summary.dart';
import 'package:depenses/layers/technical/Theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import '../../../../../support/test_dependencies.dart';
import '../../forecast_seed.dart';
import '../../forecast_test_app.dart';

void main() {
  late TestDependencies dependencies;

  setUpAll(prepareTestLocalization);
  setUp(() {
    dependencies = TestDependencies(
      today: DateTime(2026, 10, 15),
      data: {
        'expenses': [
          forecastExpense('a', 150, '2026-10-03'),
          forecastExpense('b', 30, '2026-10-08', category: 'loi'),
          forecastExpense('c', 90, '2026-09-04'),
          forecastExpense('d', 60, '2026-09-20', category: 'tra'),
        ],
        'recs': [forecastRecurrence('r1', 'Sport', 12, '2026-10-01', frequency: 'week')],
        'envelopes': {'ali': 120},
        'settings': {'income': 2000, 'payDay': 25, 'balance': 900, 'balanceDate': '2026-10-15'},
      },
    );
    GetIt.I
      ..registerFactory(() => dependencies.get<ForecastCubit>())
      ..registerFactory(() => dependencies.get<CompareCubit>());
  });
  tearDown(() async {
    await GetIt.I.reset();
    await dependencies.dispose();
  });

  for (final style in AppStyle.values) {
    testWidgets('the forecast page renders its sections in ${style.name}', (tester) async {
      await tester.pumpWidget(testApp(style, const ForecastPage()));
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.textContaining('Prévision · '), findsOneWidget);
      expect(find.text('Récurrences prévues'), findsOneWidget);
    });

    testWidgets('the compare page renders and switches to the whole month in ${style.name}', (tester) async {
      await tester.pumpWidget(testApp(style, const ComparePage()));
      await tester.pump();
      expect(find.byType(CompareMoveRow), findsNWidgets(2));
      expect(find.byType(CompareInsight), findsOneWidget);

      await tester.tap(find.textContaining(style == AppStyle.graphite ? 'AU 15' : 'À date (au 15)'));
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.textContaining(style == AppStyle.graphite ? 'MOIS ENTIER' : 'Mois entier'), findsOneWidget);
      expect(find.byType(CompareMoveRow), findsNWidgets(3));
    });

    testWidgets('the home pieces render and the bell opens the alerts in ${style.name}', (tester) async {
      final cubit = dependencies.get<ForecastSummaryCubit>();
      addTearDown(cubit.close);
      final state = cubit.state;
      final summary = state.summary!;
      await tester.pumpWidget(
        testApp(
          style,
          Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  ForecastAlertBell(alerts: summary.alerts, categories: state.categories, areAlertsEnabled: true),
                  ForecastSpentSummary(stats: summary.stats, isAccountHero: true),
                  ForecastBudgetMeter(stats: summary.stats, isAccountHero: true),
                  ForecastSpentHero(stats: summary.stats, isAccountHero: false),
                  ForecastSparklineCard(stats: summary.stats),
                  ForecastMovesCard(
                    hasPrevious: true,
                    largestMoves: summary.largestMoves,
                    categories: state.categories,
                  ),
                  ForecastAlertCallout(alert: summary.alerts.first, categoryName: 'Alimentation'),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(find.textContaining('Budget Alimentation dépassé', findRichText: true), findsOneWidget);

      await tester.tap(find.byType(ForecastAlertBell));
      await tester.pump(const Duration(seconds: 1));

      expect(tester.takeException(), isNull);
      expect(find.byType(ForecastAlertList), findsOneWidget);
    });
  }
}
