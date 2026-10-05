import 'package:depenses/layers/functional/Budget/domain/entities/category_envelope.dart';
import 'package:depenses/layers/technical/Theme/app_pressable.dart';
import 'package:depenses/layers/technical/Theme/app_progress_bar.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import 'budget_category_badge.dart';
import 'budget_envelope_note.dart';
import 'budget_envelope_sheet.dart';
import 'budget_spent_of_amount.dart';

class BudgetCategoryEnvelopeRow extends StatelessWidget {
  const BudgetCategoryEnvelopeRow({super.key, required this.envelope, required this.day, required this.daysInMonth});

  final CategoryEnvelope envelope;
  final int day;
  final int daysInMonth;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isGraphite = tokens.isGraphite;
    final isOver = envelope.isProjectedOver;
    final indent = EdgeInsets.only(left: isGraphite ? 48 : 0);
    return AppPressable(
      onTap: () => BudgetEnvelopeSheet.open(context, envelope),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              BudgetCategoryBadge(category: envelope.category, size: isGraphite ? 34 : 32),
              SizedBox(width: isGraphite ? 14 : 10),
              Expanded(
                child: Text(
                  envelope.category.name,
                  style: tokens.ts(15, isGraphite ? FontWeight.w400 : FontWeight.w700),
                ),
              ),
              BudgetSpentOfAmount(spent: envelope.spent, budget: envelope.hasEnvelope ? envelope.budget : null),
            ],
          ),
          if (envelope.hasEnvelope) ...[
            SizedBox(height: isGraphite ? 10 : 8),
            Padding(
              padding: indent,
              child: AppProgressBar(
                envelope.usedRatio,
                marker: isGraphite ? null : envelope.projectedRatio,
                fill: isOver ? tokens.warnFill : (isGraphite ? tokens.ink : tokens.mintFill),
              ),
            ),
          ],
          if (!isGraphite || isOver || !envelope.hasEnvelope) ...[
            const SizedBox(height: 6),
            Padding(
              padding: indent,
              child: BudgetEnvelopeNote(envelope: envelope, day: day, daysInMonth: daysInMonth),
            ),
          ],
        ],
      ),
    );
  }
}
