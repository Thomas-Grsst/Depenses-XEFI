import 'package:depenses/layers/technical/Theme/app_pressable.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/account_summary.dart';
import 'account_balance_hero.dart';
import 'account_balance_prompt.dart';
import 'account_balance_summary.dart';
import 'account_end_of_month_sheet.dart';
import 'account_payday_text.dart';

class AccountBalanceCard extends StatelessWidget {
  const AccountBalanceCard({super.key, required this.summary, required this.today});

  final AccountSummary summary;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    if (!summary.hasBalance) return const AccountBalancePrompt();
    final paydayText = accountPaydayText(context, summary, today);
    return AppPressable(
      onTap: () => AccountEndOfMonthSheet.show(context, month: today),
      child: context.tokens.isGraphite
          ? AccountBalanceSummary(summary: summary, paydayText: paydayText)
          : AccountBalanceHero(summary: summary, paydayText: paydayText),
    );
  }
}
