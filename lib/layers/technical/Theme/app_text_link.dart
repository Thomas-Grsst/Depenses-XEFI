import 'package:flutter/material.dart';

import 'app_pressable.dart';
import 'app_tokens_context.dart';

class AppTextLink extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const AppTextLink(this.text, {super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final style = tokens.isGraphite
        ? tokens.ts(13, FontWeight.w400, tokens.muted)
        : tokens.ts(13, FontWeight.w700, tokens.mint);
    return AppPressable(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(text, style: style),
      ),
    );
  }
}
