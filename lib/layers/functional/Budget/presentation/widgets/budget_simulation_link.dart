import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Navigation/app_route.dart';
import 'package:depenses/layers/technical/Navigation/open_route.dart';
import 'package:depenses/layers/technical/Theme/app_icon.dart';
import 'package:depenses/layers/technical/Theme/app_pressable.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../l10n/budget_locale.dart';

class BudgetSimulationLink extends StatelessWidget {
  const BudgetSimulationLink({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final title = context.tr(BudgetLocale.simulate);
    return AppPressable(
      onTap: () => openRoute<void>(context, AppRoute.simulation),
      child: tokens.isGraphite
          ? Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: tokens.lineStrong),
              ),
              child: Row(
                children: [
                  Expanded(child: Text(title, style: tokens.ts(15, FontWeight.w400))),
                  AppIcon('arrowR', size: 18, color: tokens.ink),
                ],
              ),
            )
          : Container(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 14, AppSpacing.lg, 14),
              decoration: BoxDecoration(color: tokens.mintSoft, borderRadius: BorderRadius.circular(18)),
              child: Row(
                children: [
                  AppIcon('flask', size: 22, color: tokens.mint),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: tokens.ts(15, FontWeight.w800)),
                        Text(
                          context.tr(BudgetLocale.simulateExample),
                          style: tokens.ts(12, FontWeight.w600, tokens.muted),
                        ),
                      ],
                    ),
                  ),
                  AppIcon('chevR', size: 18, color: tokens.ink),
                ],
              ),
            ),
    );
  }
}
