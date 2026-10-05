import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_button.dart';
import 'package:depenses/layers/technical/Theme/app_panel.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../l10n/budget_locale.dart';
import 'budget_envelopes_sheet.dart';

class BudgetIntroPanel extends StatelessWidget {
  const BudgetIntroPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return AppPanel(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(context.tr(BudgetLocale.introTitle), style: tokens.ts(17, tokens.wStrong)),
          const SizedBox(height: 6),
          Text(
            context.tr(BudgetLocale.introBody),
            style: tokens.ts(14, tokens.wBody, tokens.muted).copyWith(height: 1.45),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton.primary(context.tr(BudgetLocale.defineEnvelopes), onTap: () => BudgetEnvelopesSheet.open(context)),
        ],
      ),
    );
  }
}
