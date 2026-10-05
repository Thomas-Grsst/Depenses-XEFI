import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../l10n/budget_locale.dart';

class BudgetSpentOfAmount extends StatelessWidget {
  const BudgetSpentOfAmount({super.key, required this.spent, required this.budget, this.showsSpentCents = false});

  final double spent;
  final double? budget;
  final bool showsSpentCents;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final money = context.money;
    final limit = budget;
    if (tokens.isGraphite) {
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(text: money.wholeNumber(spent)),
            if (limit != null)
              TextSpan(
                text: context.trWith(BudgetLocale.trailingOutOf, [money.wholeNumber(limit)]),
                style: TextStyle(color: tokens.faint),
              ),
          ],
        ),
        style: tokens.mono(13),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(showsSpentCents ? money.euros(spent) : money.autoEuros(spent), style: tokens.ts(14, FontWeight.w800)),
        if (limit != null)
          Text(
            context.trWith(BudgetLocale.trailingOutOf, [money.autoEuros(limit)]),
            style: tokens.ts(13, FontWeight.w600, tokens.muted),
          ),
      ],
    );
  }
}
