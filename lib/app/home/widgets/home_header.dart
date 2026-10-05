import 'package:depenses/layers/functional/Forecast/presentation/cubit/forecast_summary_state.dart';
import 'package:depenses/layers/functional/Forecast/presentation/widgets/forecast_alert_bell.dart';
import 'package:depenses/layers/technical/Localization/capitalize.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/home_lists_cubit.dart';
import '../l10n/home_locale.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.forecast});

  final ForecastSummaryState forecast;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final lists = context.watch<HomeListsCubit>().state;
    final summary = forecast.summary!;
    final bell = ForecastAlertBell(
      alerts: summary.alerts,
      categories: forecast.categories,
      areAlertsEnabled: summary.areAlertsEnabled,
    );
    if (tokens.isGraphite) {
      return Row(
        children: [
          Expanded(
            child: Text(
              capitalize(context.dates.monthName(summary.stats.month)),
              style: tokens.ts(15, FontWeight.w500),
            ),
          ),
          bell,
        ],
      );
    }
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.dates.longDate(lists.today, today: lists.today),
                style: tokens.ts(14, FontWeight.w600, tokens.muted),
              ),
              Text(
                context.trWith(HomeLocale.greeting, [lists.name]),
                overflow: TextOverflow.ellipsis,
                style: tokens.ts(26, FontWeight.w800).copyWith(letterSpacing: -0.5),
              ),
            ],
          ),
        ),
        bell,
      ],
    );
  }
}
