import 'package:depenses/layers/functional/Categories/domain/entities/category.dart';
import 'package:depenses/layers/functional/Categories/domain/entities/merchant_look.dart';
import 'package:depenses/layers/functional/Expenses/domain/entities/expense.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_item_row.dart';
import 'package:depenses/layers/technical/Theme/app_ruled.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../l10n/savings_locale.dart';
import 'savings_expense_badge.dart';

class SavingsRoundedExpenseRow extends StatelessWidget {
  const SavingsRoundedExpenseRow({super.key, required this.expense, required this.look, required this.category});

  final Expense expense;
  final MerchantLook look;
  final Category category;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final money = context.money;
    return AppRuled(
      child: AppItemRow(
        leading: SavingsExpenseBadge(look: look, category: category, size: 32),
        title: expense.name,
        subtitle: context.trWith(SavingsLocale.roundedDetail, [
          context.dates.shortDate(expense.date),
          money.euros(expense.amount),
          money.wholeEuros(expense.debited),
        ]),
        trailingWidget: Text(
          context.trWith(SavingsLocale.gain, [money.euros(expense.roundUp)]),
          style: tokens.ts(14, tokens.wItem, tokens.mint),
        ),
      ),
    );
  }
}
