import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Localization/localization_locale.dart';
import 'package:depenses/layers/technical/Theme/app_big_amount.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/expense_kind_filter.dart';
import '../l10n/expenses_locale.dart';

class ExpensesTotal extends StatelessWidget {
  const ExpensesTotal({super.key, required this.total, required this.count, required this.kind});

  final double total;
  final int count;
  final ExpenseKindFilter kind;

  String _countKey() {
    final isPlural = count > 1;
    return switch (kind) {
      ExpenseKindFilter.recurring => isPlural ? ExpensesLocale.countRecurringOther : ExpensesLocale.countRecurringOne,
      ExpenseKindFilter.occasional =>
        isPlural ? ExpensesLocale.countOccasionalOther : ExpensesLocale.countOccasionalOne,
      ExpenseKindFilter.all => isPlural ? ExpensesLocale.countAllOther : ExpensesLocale.countAllOne,
    };
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final countText = context.trWith(_countKey(), ['$count']);
    if (tokens.isGraphite) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBigAmount(
            context.money.decimals(total),
            currency: context.tr(LocalizationLocale.currencySymbol),
            size: 52,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(countText.toUpperCase(), style: tokens.label()),
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Expanded(
          child: Text(context.money.euros(total), style: tokens.ts(26, FontWeight.w800).copyWith(letterSpacing: -0.5)),
        ),
        Text(countText, style: tokens.ts(13, FontWeight.w600, tokens.muted)),
      ],
    );
  }
}
