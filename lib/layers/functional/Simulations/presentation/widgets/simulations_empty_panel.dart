import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Navigation/push_page.dart';
import 'package:depenses/layers/technical/Theme/app_button.dart';
import 'package:depenses/layers/technical/Theme/app_panel.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../l10n/simulations_locale.dart';
import '../views/simulation_page.dart';

class SimulationsEmptyPanel extends StatelessWidget {
  const SimulationsEmptyPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return AppPanel(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(context.tr(SimulationsLocale.emptyTitle), style: tokens.ts(17, tokens.wStrong)),
          const SizedBox(height: 6),
          Text(
            context.tr(SimulationsLocale.emptyMessage),
            style: tokens.ts(14, tokens.wBody, tokens.muted).copyWith(height: 1.45),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton.primary(
            context.tr(SimulationsLocale.newSimulation),
            onTap: () => pushPage<void>(context, const SimulationPage()),
          ),
        ],
      ),
    );
  }
}
