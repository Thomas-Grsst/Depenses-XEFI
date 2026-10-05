import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

class ExpenseLabelChips extends StatelessWidget {
  const ExpenseLabelChips({super.key, required this.labels});

  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs),
      child: Wrap(
        spacing: AppSpacing.xs,
        runSpacing: AppSpacing.xs,
        children: [
          for (final label in labels)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
              decoration: BoxDecoration(color: tokens.chip, borderRadius: BorderRadius.circular(999)),
              child: Text(label, style: tokens.ts(11, FontWeight.w700, tokens.muted)),
            ),
        ],
      ),
    );
  }
}
