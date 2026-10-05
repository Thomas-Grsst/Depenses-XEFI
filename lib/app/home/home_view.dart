import 'package:depenses/layers/functional/Account/presentation/cubit/account_summary_cubit.dart';
import 'package:depenses/layers/functional/Account/presentation/widgets/account_balance_card.dart';
import 'package:depenses/layers/functional/Forecast/presentation/cubit/forecast_summary_cubit.dart';
import 'package:depenses/layers/functional/Forecast/presentation/widgets/forecast_alert_callout.dart';
import 'package:depenses/layers/functional/Forecast/presentation/widgets/forecast_budget_meter.dart';
import 'package:depenses/layers/functional/Forecast/presentation/widgets/forecast_moves_card.dart';
import 'package:depenses/layers/functional/Forecast/presentation/widgets/forecast_sparkline_card.dart';
import 'package:depenses/layers/functional/Forecast/presentation/widgets/forecast_spent_hero.dart';
import 'package:depenses/layers/functional/Forecast/presentation/widgets/forecast_spent_summary.dart';
import 'package:depenses/layers/technical/Theme/app_page_list.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:depenses/layers/technical/Theme/app_two_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/home_header.dart';
import 'widgets/home_recent_section.dart';
import 'widgets/home_round_up_card.dart';
import 'widgets/home_upcoming_section.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final forecast = context.watch<ForecastSummaryCubit>().state;
    final account = context.watch<AccountSummaryCubit>().state;
    final summary = forecast.summary;
    if (summary == null) return const SizedBox.shrink();
    final stats = summary.stats;
    final isAccountHero = account.summary.hasBalance;
    final isGraphite = context.tokens.isGraphite;
    final firstAlert = summary.alerts.isEmpty ? null : summary.alerts.first;
    final alert = firstAlert == null
        ? null
        : ForecastAlertCallout(
            alert: firstAlert,
            categoryName: forecast.categories[firstAlert.categoryKey]?.name ?? '',
          );
    return AppPageList(
      children: [
        HomeHeader(forecast: forecast),
        AccountBalanceCard(summary: account.summary, today: account.today ?? stats.today),
        if (isGraphite) ...[
          ForecastSpentSummary(stats: stats, isAccountHero: isAccountHero),
          ForecastBudgetMeter(stats: stats, isAccountHero: isAccountHero),
          const HomeRoundUpCard(),
          ForecastSparklineCard(stats: stats),
          ?alert,
        ] else ...[
          ForecastSpentHero(stats: stats, isAccountHero: isAccountHero),
          const HomeRoundUpCard(),
          ?alert,
          AppTwoUp(
            ForecastSparklineCard(stats: stats),
            ForecastMovesCard(
              hasPrevious: stats.hasPrevious,
              largestMoves: summary.largestMoves,
              categories: forecast.categories,
            ),
          ),
        ],
        const HomeUpcomingSection(),
        const HomeRecentSection(),
      ],
    );
  }
}
