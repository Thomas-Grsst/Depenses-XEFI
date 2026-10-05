import 'package:depenses/layers/functional/Categories/domain/entities/category.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_icon_badge.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/category_move.dart';
import '../l10n/forecast_locale.dart';

class ForecastMoveLine extends StatelessWidget {
  const ForecastMoveLine({super.key, required this.move, required this.category});

  final CategoryMove move;
  final Category category;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final ratio = move.ratio;
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        children: [
          AppIconBadge(icon: category.icon, color: tokens.swatch(category.colorIndex), size: 22),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(category.shortName, overflow: TextOverflow.ellipsis, style: tokens.ts(13, FontWeight.w600)),
          ),
          const SizedBox(width: 6),
          Text(
            ratio == null ? context.tr(ForecastLocale.newCategory) : context.money.signedPercent(ratio),
            style: tokens.ts(13, FontWeight.w600, move.delta > 0 ? tokens.warn : tokens.mint),
          ),
        ],
      ),
    );
  }
}
