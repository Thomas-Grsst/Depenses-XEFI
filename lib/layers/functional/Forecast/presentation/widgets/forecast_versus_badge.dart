import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../l10n/forecast_locale.dart';
import 'forecast_hero_colors.dart';

class ForecastVersusBadge extends StatelessWidget {
  const ForecastVersusBadge({
    super.key,
    required this.versusPrevious,
    required this.previousMonthName,
    required this.isAccountHero,
  });

  final double versusPrevious;
  final String previousMonthName;
  final bool isAccountHero;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = ForecastHeroColors(tokens, isAccountHero: isAccountHero);
    final isFalling = versusPrevious <= 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isFalling ? colors.fallingBackground : colors.rising.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        context.trWith(ForecastLocale.versusMonth, [context.money.signedPercent(versusPrevious), previousMonthName]),
        style: tokens.ts(13, FontWeight.w700, isFalling ? colors.falling : colors.rising),
      ),
    );
  }
}
