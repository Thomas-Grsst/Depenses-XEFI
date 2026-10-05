import 'package:depenses/layers/functional/Budget/domain/entities/category_envelope.dart';
import 'package:depenses/layers/functional/Forecast/domain/entities/month_stats.dart';
import 'package:depenses/layers/technical/Theme/app_panel.dart';
import 'package:depenses/layers/technical/Theme/app_ruled.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import 'budget_category_envelope_row.dart';

class BudgetCategoryEnvelopeList extends StatelessWidget {
  const BudgetCategoryEnvelopeList({super.key, required this.envelopes, required this.stats});

  final List<CategoryEnvelope> envelopes;
  final MonthStats stats;

  @override
  Widget build(BuildContext context) {
    final isGraphite = context.tokens.isGraphite;
    final rows = [
      for (final envelope in envelopes)
        AppRuled(
          verticalPadding: isGraphite ? 16 : 22,
          child: BudgetCategoryEnvelopeRow(envelope: envelope, day: stats.day, daysInMonth: stats.daysInMonth),
        ),
    ];
    if (isGraphite) return Column(children: rows);
    return AppPanel(
      radius: 22,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      child: Column(children: rows),
    );
  }
}
