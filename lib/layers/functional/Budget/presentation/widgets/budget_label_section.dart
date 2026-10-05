import 'package:depenses/layers/functional/Budget/domain/entities/label_envelope_progress.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_button.dart';
import 'package:depenses/layers/technical/Theme/app_panel.dart';
import 'package:depenses/layers/technical/Theme/app_ruled.dart';
import 'package:depenses/layers/technical/Theme/app_section_label.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:depenses/layers/technical/Theme/spaced.dart';
import 'package:flutter/material.dart';

import '../l10n/budget_locale.dart';
import 'budget_label_envelope_row.dart';
import 'budget_label_envelope_sheet.dart';

class BudgetLabelSection extends StatelessWidget {
  const BudgetLabelSection({super.key, required this.envelopes});

  final List<LabelEnvelopeProgress> envelopes;

  @override
  Widget build(BuildContext context) {
    final isGraphite = context.tokens.isGraphite;
    final rows = [for (final progress in envelopes) BudgetLabelEnvelopeRow(progress: progress)];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSectionLabel(context.tr(isGraphite ? BudgetLocale.labelSectionShort : BudgetLocale.labelSection)),
        SizedBox(height: isGraphite ? AppSpacing.md : AppSpacing.sm),
        if (rows.isNotEmpty)
          isGraphite
              ? Column(
                  children: [
                    for (var i = 0; i < rows.length; i++)
                      AppRuled(verticalPadding: 16, bottom: i == rows.length - 1, child: rows[i]),
                  ],
                )
              : Column(children: spaced([for (final row in rows) AppPanel(child: row)], AppSpacing.sm)),
        SizedBox(height: rows.isEmpty ? 0 : AppSpacing.sm),
        AppButton.dashed(context.tr(BudgetLocale.newEnvelope), onTap: () => BudgetLabelEnvelopeSheet.open(context)),
      ],
    );
  }
}
