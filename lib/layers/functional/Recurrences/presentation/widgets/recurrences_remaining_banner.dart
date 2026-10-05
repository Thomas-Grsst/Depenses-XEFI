import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../l10n/recurrences_locale.dart';

class RecurrencesRemainingBanner extends StatelessWidget {
  const RecurrencesRemainingBanner({super.key, required this.total});

  final double total;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isGraphite = tokens.isGraphite;
    final row = Row(
      children: [
        Expanded(
          child: Text(
            context.tr(RecurrencesLocale.remainingThisMonth),
            style: isGraphite ? tokens.ts(14, FontWeight.w400, tokens.muted) : tokens.ts(14, FontWeight.w700),
          ),
        ),
        Text(context.money.euros(total), style: tokens.ts(14, isGraphite ? FontWeight.w400 : FontWeight.w700)),
      ],
    );
    if (isGraphite) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        decoration: BoxDecoration(
          border: Border.symmetric(horizontal: BorderSide(color: tokens.line)),
        ),
        child: row,
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 14),
      decoration: BoxDecoration(color: tokens.mintSoft, borderRadius: BorderRadius.circular(18)),
      child: row,
    );
  }
}
