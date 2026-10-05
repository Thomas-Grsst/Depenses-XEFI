import 'package:depenses/layers/functional/Savings/domain/gateways/goal_gateway.dart';
import 'package:depenses/layers/functional/Savings/presentation/cubit/savings_cubit.dart';
import 'package:depenses/layers/functional/Savings/presentation/cubit/savings_goals_cubit.dart';
import 'package:depenses/layers/functional/Savings/presentation/cubit/savings_summary_cubit.dart';
import 'package:depenses/layers/functional/Savings/presentation/views/savings_page.dart';
import 'package:depenses/layers/functional/Savings/presentation/widgets/savings_goal_sheet.dart';
import 'package:depenses/layers/functional/Savings/presentation/widgets/savings_goal_tile.dart';
import 'package:depenses/layers/functional/Savings/presentation/widgets/savings_round_up_card.dart';
import 'package:depenses/layers/functional/Savings/presentation/widgets/savings_rounded_expense_row.dart';
import 'package:depenses/layers/technical/Theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import '../../../../../support/test_dependencies.dart';
import '../../../Forecast/forecast_test_app.dart';
import '../../savings_seed.dart';

void main() {
  late TestDependencies dependencies;

  setUpAll(prepareTestLocalization);
  setUp(() {
    dependencies = TestDependencies(
      today: DateTime(2026, 10, 15),
      data: {
        'expenses': [
          savingsExpense('a', 'Boulangerie', 1.25, '2026-10-01', roundUp: 0.75),
          savingsExpense('b', 'Netflix', 9.5, '2026-10-09', roundUp: 0.5),
        ],
        'goals': [savingsGoal('g1', 'Vacances', target: 1500, saved: 300, monthly: 100)],
      },
    );
    GetIt.I
      ..registerFactory(() => dependencies.get<SavingsCubit>())
      ..registerFactory(() => dependencies.get<SavingsGoalsCubit>());
  });
  tearDown(() async {
    await GetIt.I.reset();
    await dependencies.dispose();
  });

  for (final style in AppStyle.values) {
    testWidgets('the round-up page moves the round-ups to a goal in ${style.name}', (tester) async {
      await tester.pumpWidget(testApp(style, const SavingsPage()));
      await tester.pump();
      expect(find.byType(SavingsRoundedExpenseRow), findsNWidgets(2));
      expect(find.byType(SavingsGoalTile), findsOneWidget);

      await tester.tap(find.textContaining('dans « Vacances »'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(tester.takeException(), isNull);
      expect(dependencies.get<GoalGateway>().all().single.saved, 301.25);
      expect(find.textContaining('Vacances : '), findsOneWidget);
    });

    testWidgets('a goal can be created from the goals section in ${style.name}', (tester) async {
      await tester.pumpWidget(testApp(style, const SavingsPage()));
      await tester.pump();

      await tester.tap(find.text(style == AppStyle.graphite ? '+ Nouveau' : '+ Nouvel objectif'));
      await tester.pumpAndSettle();
      expect(find.byType(SavingsGoalSheet), findsOneWidget);
      await tester.enterText(find.byType(TextField).at(1), '2000');
      await tester.tap(find.text('Enregistrer'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(dependencies.get<GoalGateway>().all().map((g) => g.name), ['Vacances', 'Objectif']);
      expect(find.byType(SavingsGoalTile), findsNWidgets(2));
    });

    testWidgets('the home round-up card renders in ${style.name}', (tester) async {
      final cubit = dependencies.get<SavingsSummaryCubit>();
      addTearDown(cubit.close);
      final state = cubit.state;
      await tester.pumpWidget(
        testApp(
          style,
          Scaffold(
            body: SavingsRoundUpCard(summary: state.summary, month: state.month!, lastRounded: state.lastRounded),
          ),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.textContaining('depuis le début'), findsOneWidget);
    });
  }
}
