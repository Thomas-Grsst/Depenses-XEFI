import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Navigation/app_route.dart';
import 'package:depenses/layers/technical/Navigation/open_route.dart';
import 'package:depenses/layers/technical/Theme/app_button.dart';
import 'package:depenses/layers/technical/Theme/app_callout.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:flutter/material.dart';

import '../l10n/bank_sync_locale.dart';

class BankLinkPrompt extends StatelessWidget {
  const BankLinkPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppCallout.tip(parts: [(context.tr(BankSyncLocale.linkPrompt), false)]),
        const SizedBox(height: AppSpacing.lg),
        AppButton.primary(
          context.tr(BankSyncLocale.linkBank),
          icon: 'plus',
          onTap: () => openRoute<void>(context, AppRoute.bankPicker),
        ),
      ],
    );
  }
}
