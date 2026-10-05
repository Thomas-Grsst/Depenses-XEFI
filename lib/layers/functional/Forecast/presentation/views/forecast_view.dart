import 'package:depenses/layers/technical/Localization/capitalize.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_back_header.dart';
import 'package:depenses/layers/technical/Theme/app_page_list.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/forecast_cubit.dart';
import '../cubit/forecast_state.dart';
import '../l10n/forecast_locale.dart';
import '../widgets/forecast_basis.dart';
import '../widgets/forecast_chart_panel.dart';
import '../widgets/forecast_key_figures.dart';
import '../widgets/forecast_pace_tip.dart';
import '../widgets/forecast_remaining_section.dart';

class ForecastView extends StatelessWidget {
  const ForecastView({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Scaffold(
      backgroundColor: tokens.bg,
      body: BlocBuilder<ForecastCubit, ForecastState>(
        builder: (context, state) {
          final stats = state.stats;
          if (stats == null) return const SizedBox.shrink();
          final monthName = context.dates.monthName(stats.month);
          return AppPageList(
            children: [
              AppBackHeader(
                context.trWith(ForecastLocale.title, [tokens.isGraphite ? capitalize(monthName) : monthName]),
                backLabel: context.tr(ForecastLocale.back),
              ),
              ForecastKeyFigures(stats: stats),
              ForecastChartPanel(stats: stats),
              ForecastPaceTip(stats: stats),
              ForecastRemainingSection(
                stats: stats,
                account: state.account,
                remainingRecurrences: state.remainingRecurrences,
              ),
              const ForecastBasis(),
            ],
          );
        },
      ),
    );
  }
}
