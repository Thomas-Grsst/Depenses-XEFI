import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Localization/localization_locale.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../l10n/onboarding_locale.dart';
import 'onboarding_pay_day_button.dart';

const _daysInLongestMonth = 31;
const _daysInShortestMonth = 28;
const _decreaseSymbol = '−';
const _increaseSymbol = '+';

class OnboardingPayDayPicker extends StatelessWidget {
  const OnboardingPayDayPicker({super.key, required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  int _shifted(int direction) =>
      ((value - 1 + direction) % _daysInLongestMonth + _daysInLongestMonth) % _daysInLongestMonth + 1;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final graphite = tokens.isGraphite;
    final title = graphite
        ? context.tr(OnboardingLocale.payDayTitleGraphite).toUpperCase()
        : context.tr(OnboardingLocale.payDayTitleMenthe);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: tokens.label()),
        const SizedBox(height: 8),
        Row(
          children: [
            OnboardingPayDayButton(label: _decreaseSymbol, onTap: () => onChanged(_shifted(-1))),
            Expanded(
              child: Column(
                children: [
                  Text(
                    value == 1 ? context.tr(LocalizationLocale.firstDayOfMonth) : '$value',
                    style: tokens.ts(28, graphite ? FontWeight.w300 : FontWeight.w800),
                  ),
                  Text(context.tr(OnboardingLocale.ofEachMonth), style: tokens.ts(12, tokens.wSemi, tokens.muted)),
                ],
              ),
            ),
            OnboardingPayDayButton(label: _increaseSymbol, onTap: () => onChanged(_shifted(1))),
          ],
        ),
        if (value > _daysInShortestMonth)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              context.tr(OnboardingLocale.shortMonths),
              textAlign: TextAlign.center,
              style: tokens.ts(12, tokens.wSemi, tokens.muted),
            ),
          ),
      ],
    );
  }
}
