import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Navigation/app_route.dart';
import 'package:depenses/layers/technical/Navigation/open_route.dart';
import 'package:depenses/layers/technical/Theme/app_button.dart';
import 'package:depenses/layers/technical/Theme/app_panel.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../l10n/recurrences_locale.dart';

class RecurrencesEmptyPanel extends StatelessWidget {
  const RecurrencesEmptyPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return AppPanel(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.tr(RecurrencesLocale.emptyTitle), style: tokens.ts(17, tokens.wStrong)),
          const SizedBox(height: 6),
          Text(
            context.tr(RecurrencesLocale.emptyBody),
            style: tokens.ts(14, tokens.wBody, tokens.muted).copyWith(height: 1.45),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton.primary(
            context.tr(RecurrencesLocale.addRecurrence),
            onTap: () => openRoute<void>(context, AppRoute.newRecurrence),
          ),
        ],
      ),
    );
  }
}
