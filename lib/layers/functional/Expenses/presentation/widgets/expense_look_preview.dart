import 'package:depenses/layers/functional/Categories/domain/entities/category.dart';
import 'package:depenses/layers/functional/Categories/domain/entities/merchant_look.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../l10n/expenses_locale.dart';
import 'expense_badge.dart';

class ExpenseLookPreview extends StatelessWidget {
  const ExpenseLookPreview({super.key, required this.category, required this.look});

  final Category category;
  final MerchantLook look;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Row(
      children: [
        ExpenseBadge(category: category, look: look, size: 28),
        const SizedBox(width: 10),
        Expanded(child: Text(context.tr(ExpensesLocale.lookPreview), style: tokens.ts(12, tokens.wSemi, tokens.muted))),
      ],
    );
  }
}
