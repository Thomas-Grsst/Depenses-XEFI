import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_back_header.dart';
import 'package:depenses/layers/technical/Theme/app_page_list.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/compare_cubit.dart';
import '../cubit/compare_state.dart';
import '../l10n/forecast_compare_locale.dart';
import '../widgets/compare_breakdown.dart';
import '../widgets/compare_empty_panel.dart';
import '../widgets/compare_graphite_header.dart';
import '../widgets/compare_graphite_hero.dart';
import '../widgets/compare_insight.dart';
import '../widgets/compare_menthe_controls.dart';
import '../widgets/compare_menthe_hero.dart';

class CompareView extends StatelessWidget {
  const CompareView({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final graphite = tokens.isGraphite;
    return Scaffold(
      backgroundColor: tokens.bg,
      body: BlocBuilder<CompareCubit, CompareState>(
        builder: (context, state) {
          final comparison = state.comparison;
          if (comparison == null) return const SizedBox.shrink();
          final hasInsight = comparison.biggestDrop != null || comparison.biggestRise != null;
          return AppPageList(
            children: [
              if (graphite)
                CompareGraphiteHeader(comparison: comparison)
              else
                AppBackHeader(
                  context.tr(ForecastCompareLocale.title),
                  backLabel: context.tr(ForecastCompareLocale.back),
                ),
              if (!graphite) CompareMentheControls(comparison: comparison),
              if (!comparison.hasReferenceData)
                CompareEmptyPanel(referenceMonth: comparison.referenceMonth)
              else ...[
                if (graphite)
                  CompareGraphiteHero(comparison: comparison)
                else
                  CompareMentheHero(comparison: comparison),
                if (comparison.moves.isNotEmpty) CompareBreakdown(comparison: comparison, categories: state.categories),
                if (hasInsight) CompareInsight(comparison: comparison, categories: state.categories),
              ],
            ],
          );
        },
      ),
    );
  }
}
