import 'package:depenses/layers/functional/Categories/domain/entities/category.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Navigation/app_route.dart';
import 'package:depenses/layers/technical/Navigation/open_route.dart';
import 'package:depenses/layers/technical/Theme/app_panel.dart';
import 'package:depenses/layers/technical/Theme/app_pressable.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/category_move.dart';
import '../l10n/forecast_locale.dart';
import 'forecast_move_line.dart';

const _shownMoves = 3;

class ForecastMovesCard extends StatelessWidget {
  const ForecastMovesCard({super.key, required this.hasPrevious, required this.largestMoves, required this.categories});

  final bool hasPrevious;
  final List<CategoryMove> largestMoves;
  final Map<String, Category> categories;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final style = tokens.ts(13, FontWeight.w600, tokens.muted);
    final shown = [
      for (final move in largestMoves.take(_shownMoves))
        if (categories[move.categoryKey] != null) (move, categories[move.categoryKey]!),
    ];
    return AppPressable(
      onTap: () => openRoute<void>(context, AppRoute.compare),
      child: AppPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.tr(ForecastLocale.movesTitle), style: style),
            const SizedBox(height: AppSpacing.sm),
            if (!hasPrevious || shown.isEmpty)
              Text(context.tr(ForecastLocale.movesUnavailable), style: style)
            else
              for (final (move, category) in shown) ForecastMoveLine(move: move, category: category),
          ],
        ),
      ),
    );
  }
}
