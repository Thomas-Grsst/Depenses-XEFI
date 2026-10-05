import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Localization/localization_locale.dart';
import 'package:depenses/layers/technical/Theme/app_big_amount.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/account_summary.dart';
import '../l10n/account_emphasis.dart';
import '../l10n/account_locale.dart';

const _heroWarmTone = Color(0xFFF5B47A);

class AccountBalanceHero extends StatelessWidget {
  const AccountBalanceHero({super.key, required this.summary, this.paydayText});

  final AccountSummary summary;
  final String? paydayText;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final money = context.money;
    final paydayText = this.paydayText;
    final parts = accountEmphasisParts(
      context.trWith(AccountLocale.endOfMonthApprox, [money.wholeEuros(summary.endOfMonth)]),
    );
    final endStyle = TextStyle(
      color: summary.endOfMonth < 0 ? _heroWarmTone : tokens.heroInk,
      fontWeight: FontWeight.w800,
    );
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(color: tokens.hero, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.tr(AccountLocale.onYourAccount), style: tokens.ts(14, FontWeight.w600, tokens.heroMuted)),
          const SizedBox(height: AppSpacing.sm),
          AppBigAmount(
            money.decimals(summary.balance),
            currency: context.tr(LocalizationLocale.currencySymbol),
            color: summary.balance < 0 ? _heroWarmTone : tokens.heroInk,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      for (final (text, isEmphasized) in parts)
                        TextSpan(text: text, style: isEmphasized ? endStyle : null),
                    ],
                  ),
                  style: tokens.ts(14, FontWeight.w600, tokens.heroMuted),
                ),
              ),
              Text(context.tr(AccountLocale.detail), style: tokens.ts(13, FontWeight.w700, tokens.heroAccent)),
            ],
          ),
          if (paydayText != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: AppSpacing.xs),
              decoration: BoxDecoration(color: tokens.heroChip, borderRadius: BorderRadius.circular(999)),
              child: Text(paydayText, style: tokens.ts(12, FontWeight.w700, tokens.heroAccent)),
            ),
          ],
        ],
      ),
    );
  }
}
