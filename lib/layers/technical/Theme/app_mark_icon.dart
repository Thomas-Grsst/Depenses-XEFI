import 'package:flutter/material.dart';

import 'app_icon.dart';
import 'app_tokens_context.dart';

class AppMarkIcon extends StatelessWidget {
  final String icon;

  const AppMarkIcon(this.icon, {super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return AppIcon(
      icon,
      size: tokens.isGraphite ? 12 : 14,
      color: tokens.isGraphite ? tokens.muted : tokens.mint,
      stroke: 2,
    );
  }
}
