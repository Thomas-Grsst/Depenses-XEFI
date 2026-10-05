import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../l10n/expenses_locale.dart';

class ExpenseImportedTag extends StatelessWidget {
  const ExpenseImportedTag({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isGraphite = tokens.isGraphite;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: isGraphite ? Colors.transparent : tokens.mintSoft,
        borderRadius: BorderRadius.circular(999),
        border: isGraphite ? Border.all(color: tokens.lineStrong) : null,
      ),
      child: Text(
        context.tr(ExpensesLocale.imported),
        style: tokens.ts(10, tokens.wSemi, isGraphite ? tokens.muted : tokens.mint),
      ),
    );
  }
}
