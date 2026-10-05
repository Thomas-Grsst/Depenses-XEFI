import 'package:depenses/layers/functional/Categories/domain/entities/category.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_icon_badge.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/category_move.dart';
import '../l10n/forecast_compare_locale.dart';
import 'compare_move_bars.dart';

const _negligibleDelta = 0.005;

class CompareMoveRow extends StatelessWidget {
  const CompareMoveRow({
    super.key,
    required this.move,
    required this.category,
    required this.referenceMonth,
    required this.largestDelta,
  });

  final CategoryMove move;
  final Category category;
  final DateTime referenceMonth;
  final double largestDelta;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final money = context.money;
    final delta = move.delta;
    final ratio = move.ratio;
    final texts = _MoveTexts(
      category: category,
      tone: delta > _negligibleDelta ? tokens.warn : (delta < -_negligibleDelta ? tokens.mint : tokens.muted),
      ratio: ratio == null ? context.tr(ForecastCompareLocale.newCategory) : money.signedPercent(ratio),
      delta: delta.abs() < _negligibleDelta
          ? context.tr(ForecastCompareLocale.noChange)
          : money.withSign(delta, money.euros),
      detail: context.trWith(ForecastCompareLocale.moveDetail, [
        money.euros(move.current),
        context.dates.shortMonthName(referenceMonth),
        money.euros(move.previous),
      ]),
      bars: CompareMoveBars(delta: delta, share: delta.abs() / largestDelta),
    );
    return tokens.isGraphite ? _GraphiteMoveRow(texts) : _MentheMoveRow(texts);
  }
}

class _MoveTexts {
  const _MoveTexts({
    required this.category,
    required this.tone,
    required this.ratio,
    required this.delta,
    required this.detail,
    required this.bars,
  });

  final Category category;
  final Color tone;
  final String ratio;
  final String delta;
  final String detail;
  final Widget bars;
}

class _GraphiteMoveRow extends StatelessWidget {
  const _GraphiteMoveRow(this.texts);

  final _MoveTexts texts;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            AppIconBadge(icon: texts.category.icon, color: tokens.swatch(texts.category.colorIndex), size: 32),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(texts.category.name, style: tokens.ts(15, FontWeight.w400)),
                  Text(texts.detail, style: tokens.ts(12, FontWeight.w400, tokens.muted)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(texts.ratio, style: tokens.ts(15, FontWeight.w400, texts.tone)),
                Text(texts.delta, style: tokens.mono(11, tokens.muted)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        Padding(padding: const EdgeInsets.only(left: 44), child: texts.bars),
      ],
    );
  }
}

class _MentheMoveRow extends StatelessWidget {
  const _MentheMoveRow(this.texts);

  final _MoveTexts texts;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              AppIconBadge(icon: texts.category.icon, color: tokens.swatch(texts.category.colorIndex), size: 28),
              const SizedBox(width: 10),
              Expanded(child: Text(texts.category.name, style: tokens.ts(14, FontWeight.w700))),
              Text(texts.ratio, style: tokens.ts(14, FontWeight.w800, texts.tone)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(child: texts.bars),
              SizedBox(
                width: 86,
                child: Text(
                  texts.delta,
                  textAlign: TextAlign.right,
                  style: tokens.ts(12, FontWeight.w700, tokens.muted),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(texts.detail, style: tokens.ts(12, FontWeight.w500, tokens.muted)),
        ],
      ),
    );
  }
}
