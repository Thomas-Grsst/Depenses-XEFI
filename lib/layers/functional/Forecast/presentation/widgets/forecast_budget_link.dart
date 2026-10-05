import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Navigation/app_route.dart';
import 'package:depenses/layers/technical/Navigation/open_route.dart';
import 'package:depenses/layers/technical/Theme/app_icon.dart';
import 'package:depenses/layers/technical/Theme/app_pressable.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../l10n/forecast_locale.dart';

class ForecastBudgetLink extends StatelessWidget {
  const ForecastBudgetLink({super.key, required this.hasBudget, required this.isAccountHero});

  final bool hasBudget;
  final bool isAccountHero;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    if (tokens.isGraphite) {
      return AppPressable(
        onTap: () => openRoute<void>(context, AppRoute.budget),
        child: Text(
          context.tr(hasBudget ? ForecastLocale.manageBudget : ForecastLocale.defineBudget),
          style: tokens.ts(14, FontWeight.w400, tokens.muted),
        ),
      );
    }
    final ink = isAccountHero ? tokens.mint : tokens.heroInk;
    return AppPressable(
      onTap: () => openRoute<void>(context, AppRoute.budget),
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: isAccountHero ? tokens.mintSoft : tokens.heroInk.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.tr(hasBudget ? ForecastLocale.manageBudgetShort : ForecastLocale.defineBudgetShort),
              style: tokens.ts(13, FontWeight.w800, ink),
            ),
            const SizedBox(width: AppSpacing.xs),
            AppIcon('chevR', size: 14, color: ink, stroke: 2.2),
          ],
        ),
      ),
    );
  }
}
