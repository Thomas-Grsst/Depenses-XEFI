import 'package:depenses/layers/functional/Categories/domain/entities/category.dart';
import 'package:depenses/layers/functional/Categories/domain/entities/merchant_look.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../l10n/recurrences_locale.dart';
import 'occurrence_date_stack.dart';
import 'recurrences_category_badge.dart';

class OccurrenceRowLeading extends StatelessWidget {
  const OccurrenceRowLeading({
    super.key,
    required this.date,
    required this.look,
    required this.category,
    required this.isListLayout,
  });

  final DateTime date;
  final MerchantLook look;
  final Category category;
  final bool isListLayout;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    if (tokens.isGraphite) {
      if (!isListLayout) return RecurrencesCategoryBadge(look: look, category: category, size: 38);
      final numeric = context.trWith(RecurrencesLocale.numericDayMonth, [
        date.day.toString().padLeft(2, '0'),
        date.month.toString().padLeft(2, '0'),
      ]);
      return SizedBox(width: 48, child: Text(numeric, style: tokens.mono(12, tokens.muted)));
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: isListLayout
          ? [
              SizedBox(
                width: 52,
                child: Text(context.dates.shortDate(date), style: tokens.ts(13, FontWeight.w700, tokens.muted)),
              ),
              RecurrencesCategoryBadge(look: look, category: category, size: 32),
            ]
          : [
              OccurrenceDateStack(date: date),
              const SizedBox(width: AppSpacing.md),
              RecurrencesCategoryBadge(look: look, category: category, size: 36),
            ],
    );
  }
}
