import 'package:flutter/material.dart';

import 'app_spacing.dart';
import 'app_tokens_context.dart';

class AppEmptyRow extends StatelessWidget {
  final String text;

  const AppEmptyRow(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Text(text, style: tokens.ts(14, tokens.wBody, tokens.muted)),
    );
  }
}
