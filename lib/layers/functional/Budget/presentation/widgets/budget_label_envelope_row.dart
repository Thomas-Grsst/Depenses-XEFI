import 'package:depenses/layers/functional/Budget/domain/entities/label_envelope_progress.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_icon_badge.dart';
import 'package:depenses/layers/technical/Theme/app_pressable.dart';
import 'package:depenses/layers/technical/Theme/app_progress_bar.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../l10n/budget_locale.dart';
import 'budget_label_envelope_sheet.dart';
import 'budget_spent_of_amount.dart';

const _leisureSwatchIndex = 3;
const _emptyLabelLetter = '#';

class BudgetLabelEnvelopeRow extends StatelessWidget {
  const BudgetLabelEnvelopeRow({super.key, required this.progress});

  final LabelEnvelopeProgress progress;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isGraphite = tokens.isGraphite;
    final envelope = progress.envelope;
    final label = envelope.label;
    return AppPressable(
      onTap: () => BudgetLabelEnvelopeSheet.open(context, existing: envelope),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              AppIconBadge.letter(
                letter: label.isEmpty ? _emptyLabelLetter : label[0].toUpperCase(),
                color: tokens.swatch(_leisureSwatchIndex),
                size: isGraphite ? 34 : 32,
              ),
              SizedBox(width: isGraphite ? 14 : 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(envelope.name, style: tokens.ts(15, isGraphite ? FontWeight.w400 : FontWeight.w700)),
                    Text(
                      context.trWith(BudgetLocale.labelSubtitle, [label]),
                      style: tokens.ts(12, tokens.wSemi, tokens.muted),
                    ),
                  ],
                ),
              ),
              BudgetSpentOfAmount(spent: progress.spent, budget: envelope.amount, showsSpentCents: true),
            ],
          ),
          SizedBox(height: isGraphite ? 10 : 8),
          Padding(
            padding: EdgeInsets.only(left: isGraphite ? 48 : 0),
            child: AppProgressBar(
              progress.usedRatio,
              fill: progress.isOver ? tokens.warnFill : (isGraphite ? tokens.ink : tokens.mintFill),
            ),
          ),
        ],
      ),
    );
  }
}
