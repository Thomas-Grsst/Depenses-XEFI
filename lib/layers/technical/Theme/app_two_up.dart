import 'package:flutter/material.dart';

import 'app_spacing.dart';
import 'app_tokens_context.dart';

class AppTwoUp extends StatelessWidget {
  final Widget first;
  final Widget second;

  const AppTwoUp(this.first, this.second, {super.key});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: first),
          SizedBox(width: context.tokens.isGraphite ? AppSpacing.lg : AppSpacing.md),
          Expanded(child: second),
        ],
      ),
    );
  }
}
