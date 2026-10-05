import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_section_label.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../l10n/forecast_locale.dart';
import 'forecast_basis_chip.dart';

class ForecastBasis extends StatelessWidget {
  const ForecastBasis({super.key});

  static const _items = [
    ForecastLocale.basisDailyPace,
    ForecastLocale.basisRemainingRecurrences,
    ForecastLocale.basisHistory,
    ForecastLocale.basisDayOfMonth,
    ForecastLocale.basisCategoryTrends,
  ];

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final labels = [for (final item in _items) context.tr(item)];
    if (tokens.isGraphite) {
      return Text(
        context.trWith(ForecastLocale.basisInline, [
          labels.join(context.tr(ForecastLocale.listSeparator)),
        ]).toUpperCase(),
        style: tokens.mono(10, tokens.faint).copyWith(height: 1.8),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionLabel(context.tr(ForecastLocale.basisTitle)),
        const SizedBox(height: AppSpacing.sm),
        Wrap(spacing: 6, runSpacing: 6, children: [for (final label in labels) ForecastBasisChip(label)]),
      ],
    );
  }
}
