import 'package:flutter/material.dart';

import 'app_round_button.dart';
import 'app_spacing.dart';
import 'app_tokens_context.dart';

class AppBackHeader extends StatelessWidget {
  final String title;
  final String backLabel;
  final String? subtitle;
  final Widget? trailing;
  final String icon;

  const AppBackHeader(
    this.title, {
    super.key,
    required this.backLabel,
    this.subtitle,
    this.trailing,
    this.icon = 'chevL',
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final back = AppRoundButton(icon, semanticsLabel: backLabel, onTap: () => Navigator.of(context).maybePop());
    if (tokens.isGraphite) {
      return Row(
        children: [
          back,
          Expanded(
            child: Column(
              children: [
                Text(title, textAlign: TextAlign.center, style: tokens.ts(15, FontWeight.w500)),
                if (subtitle != null) Text(subtitle!.toUpperCase(), style: tokens.mono(10, tokens.muted)),
              ],
            ),
          ),
          SizedBox(
            width: 44,
            child: Align(alignment: Alignment.centerRight, child: trailing),
          ),
        ],
      );
    }
    return Row(
      children: [
        back,
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: tokens.ts(24, FontWeight.w800).copyWith(letterSpacing: -0.5)),
              if (subtitle != null) Text(subtitle!, style: tokens.ts(12, FontWeight.w600, tokens.muted)),
            ],
          ),
        ),
        ?trailing,
      ],
    );
  }
}
