import 'package:flutter/material.dart';

import 'app_spacing.dart';
import 'app_tokens_context.dart';

class AppSectionLabel extends StatelessWidget {
  final String text;
  final Widget? trailing;

  const AppSectionLabel(this.text, {super.key, this.trailing});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
      child: Row(
        children: [
          Expanded(child: Text(tokens.isGraphite ? text.toUpperCase() : text, style: tokens.label())),
          ?trailing,
        ],
      ),
    );
  }
}
