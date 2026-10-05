import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_panel.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../l10n/forecast_compare_locale.dart';

class CompareEmptyPanel extends StatelessWidget {
  const CompareEmptyPanel({super.key, required this.referenceMonth});

  final DateTime referenceMonth;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return AppPanel(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Text(
        context.trWith(ForecastCompareLocale.empty, [context.dates.monthName(referenceMonth)]),
        style: tokens.ts(14, tokens.wBody, tokens.muted).copyWith(height: 1.45),
      ),
    );
  }
}
