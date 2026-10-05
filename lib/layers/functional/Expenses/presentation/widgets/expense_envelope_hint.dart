import 'package:depenses/layers/functional/Categories/domain/entities/category.dart';
import 'package:depenses/layers/functional/Forecast/domain/entities/category_stats.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Navigation/app_route.dart';
import 'package:depenses/layers/technical/Navigation/open_route.dart';
import 'package:depenses/layers/technical/Theme/app_icon.dart';
import 'package:depenses/layers/technical/Theme/app_pressable.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../l10n/expenses_locale.dart';

class ExpenseEnvelopeHint extends StatelessWidget {
  const ExpenseEnvelopeHint({super.key, required this.category, required this.stats});

  final Category category;
  final CategoryStats? stats;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final money = context.money;
    final budget = stats?.budget ?? 0;
    final spent = stats?.spent ?? 0;
    final hasBudget = budget > 0;
    final text = hasBudget
        ? context.trWith(ExpensesLocale.envelopeStatus, [category.name, money.euros(spent), money.autoEuros(budget)])
        : context.trWith(ExpensesLocale.envelopeMissing, [category.name]);
    return AppPressable(
      onTap: () => openRoute<void>(context, AppRoute.editEnvelope, arguments: category.key),
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: AppSpacing.xxs),
        child: Row(
          children: [
            AppIcon('tag', size: 14, color: tokens.muted),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                text,
                style: tokens.ts(12, tokens.wSemi, hasBudget && spent > budget ? tokens.warn : tokens.muted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
