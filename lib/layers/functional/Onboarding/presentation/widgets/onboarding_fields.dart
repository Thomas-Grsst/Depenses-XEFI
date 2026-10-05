import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_text_field.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../l10n/onboarding_locale.dart';

class OnboardingFields extends StatelessWidget {
  const OnboardingFields({
    super.key,
    required this.name,
    required this.balance,
    required this.income,
    required this.onNameChanged,
  });

  final TextEditingController name;
  final TextEditingController balance;
  final TextEditingController income;
  final ValueChanged<String> onNameChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final helpStyle = tokens.ts(12, tokens.wSemi, tokens.muted);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          context.tr(OnboardingLocale.firstName),
          controller: name,
          hint: context.tr(OnboardingLocale.firstNameHint),
          onChanged: onNameChanged,
        ),
        const SizedBox(height: 18),
        AppTextField.number(
          context.tr(OnboardingLocale.balance),
          controller: balance,
          hint: context.tr(OnboardingLocale.balanceHint),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(context.tr(OnboardingLocale.balanceHelp), style: helpStyle),
        const SizedBox(height: 18),
        AppTextField.number(
          context.tr(OnboardingLocale.income),
          controller: income,
          hint: context.tr(OnboardingLocale.incomeHint),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(context.tr(OnboardingLocale.incomeHelp), style: helpStyle),
      ],
    );
  }
}
