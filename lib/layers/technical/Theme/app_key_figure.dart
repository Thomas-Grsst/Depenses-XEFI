import 'package:flutter/material.dart';

import 'app_spacing.dart';
import 'app_tokens_context.dart';

class AppKeyFigure extends StatelessWidget {
  final String label;
  final String amount;
  final String amountWithCurrency;
  final bool hero;

  const AppKeyFigure(this.label, {super.key, required this.amount, required this.amountWithCurrency}) : hero = false;

  const AppKeyFigure.hero(this.label, {super.key, required this.amount, required this.amountWithCurrency})
    : hero = true;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    if (tokens.isGraphite) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: tokens.label()),
          const SizedBox(height: AppSpacing.sm),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(amount, style: tokens.ts(34, FontWeight.w300).copyWith(letterSpacing: -1.2, height: 1)),
          ),
        ],
      );
    }
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(color: hero ? tokens.hero : tokens.card, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: tokens.ts(13, FontWeight.w600, hero ? tokens.heroMuted : tokens.muted)),
          const SizedBox(height: AppSpacing.xs),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(amountWithCurrency, style: tokens.ts(22, FontWeight.w800, hero ? tokens.heroInk : tokens.ink)),
          ),
        ],
      ),
    );
  }
}
