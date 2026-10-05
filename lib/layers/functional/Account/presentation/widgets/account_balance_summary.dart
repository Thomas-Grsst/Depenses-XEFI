import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Localization/localization_locale.dart';
import 'package:depenses/layers/technical/Theme/app_big_amount.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/account_summary.dart';
import '../l10n/account_emphasis.dart';
import '../l10n/account_locale.dart';

class AccountBalanceSummary extends StatelessWidget {
  const AccountBalanceSummary({super.key, required this.summary, this.paydayText});

  final AccountSummary summary;
  final String? paydayText;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final money = context.money;
    final endTone = summary.endOfMonth < 0 ? tokens.warn : tokens.ink;
    final paydayText = this.paydayText;
    final parts = accountEmphasisParts(
      context.trWith(AccountLocale.endOfMonthApprox, [money.wholeEuros(summary.endOfMonth)]),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.tr(AccountLocale.onYourAccountShort), style: tokens.label()),
        const SizedBox(height: 10),
        AppBigAmount(
          money.decimals(summary.balance),
          currency: context.tr(LocalizationLocale.currencySymbol),
          size: 68,
          color: summary.balance < 0 ? tokens.warn : null,
        ),
        const SizedBox(height: 10),
        Text.rich(
          TextSpan(
            children: [
              for (final (text, isEmphasized) in parts)
                TextSpan(
                  text: text,
                  style: isEmphasized ? TextStyle(color: endTone) : null,
                ),
              if (paydayText != null)
                TextSpan(
                  text: '${context.tr(AccountLocale.paydayDivider)}$paydayText',
                  style: TextStyle(color: tokens.mint),
                ),
            ],
          ),
          style: tokens.ts(14, FontWeight.w400, tokens.muted),
        ),
      ],
    );
  }
}
