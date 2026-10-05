import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../l10n/onboarding_locale.dart';

class OnboardingIntro extends StatelessWidget {
  const OnboardingIntro({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final graphite = tokens.isGraphite;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          graphite ? context.tr(OnboardingLocale.brand).toUpperCase() : context.tr(OnboardingLocale.welcome),
          style: graphite ? tokens.label() : tokens.ts(14, FontWeight.w700, tokens.mint),
        ),
        const SizedBox(height: 10),
        Text(
          context.tr(OnboardingLocale.headline),
          style: tokens
              .ts(graphite ? 34 : 32, graphite ? FontWeight.w300 : FontWeight.w800)
              .copyWith(height: 1.15, letterSpacing: -0.6),
        ),
        const SizedBox(height: 12),
        Text(context.tr(OnboardingLocale.privacy), style: tokens.ts(15, tokens.wBody, tokens.muted)),
      ],
    );
  }
}
