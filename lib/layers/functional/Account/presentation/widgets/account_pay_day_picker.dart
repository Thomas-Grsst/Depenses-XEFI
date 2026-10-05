import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Localization/localization_locale.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/pay_day.dart';
import '../l10n/account_locale.dart';
import 'account_pay_day_button.dart';

class AccountPayDayPicker extends StatelessWidget {
  const AccountPayDayPicker({super.key, required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final graphite = tokens.isGraphite;
    final noteStyle = tokens.ts(12, tokens.wSemi, tokens.muted);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(context.tr(graphite ? AccountLocale.payDayLabelShort : AccountLocale.payDayLabel), style: tokens.label()),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            AccountPayDayButton(context.tr(AccountLocale.previousDay), onTap: () => onChanged(PayDay.shift(value, -1))),
            Expanded(
              child: Column(
                children: [
                  Text(
                    value == 1 ? context.tr(LocalizationLocale.firstDayOfMonth) : '$value',
                    style: tokens.ts(28, graphite ? FontWeight.w300 : FontWeight.w800),
                  ),
                  Text(context.tr(AccountLocale.everyMonth), style: noteStyle),
                ],
              ),
            ),
            AccountPayDayButton(context.tr(AccountLocale.nextDay), onTap: () => onChanged(PayDay.shift(value, 1))),
          ],
        ),
        if (PayDay.fallsBackInShortMonths(value))
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(context.tr(AccountLocale.shortMonthsNote), textAlign: TextAlign.center, style: noteStyle),
          ),
      ],
    );
  }
}
