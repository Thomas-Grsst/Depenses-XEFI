import 'package:depenses/layers/functional/Categories/domain/entities/category.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Localization/localization_locale.dart';
import 'package:depenses/layers/technical/Theme/app_ruled.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../l10n/budget_locale.dart';
import 'budget_category_badge.dart';

class BudgetEnvelopeInputRow extends StatelessWidget {
  const BudgetEnvelopeInputRow({super.key, required this.category, required this.controller});

  final Category category;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return AppRuled(
      child: Row(
        children: [
          BudgetCategoryBadge(category: category, size: 32),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Text(category.name, style: tokens.ts(15, tokens.wItem))),
          SizedBox(
            width: 110,
            child: TextField(
              controller: controller,
              textAlign: TextAlign.right,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: tokens.ts(16, tokens.isGraphite ? FontWeight.w400 : FontWeight.w800),
              decoration: InputDecoration(
                isDense: true,
                hintText: context.tr(BudgetLocale.noAmountHint),
                hintStyle: tokens.ts(16, FontWeight.w400, tokens.faint),
                suffixText: context.trWith(BudgetLocale.amountSuffix, [context.tr(LocalizationLocale.currencySymbol)]),
                suffixStyle: tokens.ts(15, FontWeight.w400, tokens.muted),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
