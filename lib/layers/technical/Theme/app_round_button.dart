import 'package:flutter/material.dart';

import 'app_icon.dart';
import 'app_pressable.dart';
import 'app_tokens_context.dart';

class AppRoundButton extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;
  final String? semanticsLabel;
  final bool filled;

  const AppRoundButton(this.icon, {super.key, required this.onTap, this.semanticsLabel}) : filled = false;

  const AppRoundButton.filled(this.icon, {super.key, required this.onTap, this.semanticsLabel}) : filled = true;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final bare = tokens.isGraphite && !filled;
    return AppPressable(
      onTap: onTap,
      semanticsLabel: semanticsLabel,
      child: Container(
        width: 44,
        height: 44,
        alignment: bare ? Alignment.centerLeft : Alignment.center,
        decoration: bare ? null : BoxDecoration(color: filled ? tokens.fab : tokens.card, shape: BoxShape.circle),
        child: AppIcon(
          icon,
          size: tokens.isGraphite ? 22 : 20,
          color: filled ? tokens.fabInk : tokens.ink,
          stroke: tokens.isGraphite ? 1.4 : 2,
        ),
      ),
    );
  }
}
