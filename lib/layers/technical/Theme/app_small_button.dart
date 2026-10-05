import 'package:flutter/material.dart';

import 'app_pressable.dart';
import 'app_tokens_context.dart';

class AppSmallButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool primary;

  const AppSmallButton.primary(this.label, {super.key, required this.onTap}) : primary = true;

  const AppSmallButton.secondary(this.label, {super.key, required this.onTap}) : primary = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final graphite = tokens.isGraphite;
    final Color background = graphite
        ? (primary ? tokens.fab : Colors.transparent)
        : (primary ? tokens.mint : tokens.card);
    final Color foreground = graphite ? (primary ? tokens.fabInk : tokens.ink) : (primary ? tokens.onMint : tokens.ink);
    return AppPressable(
      onTap: onTap,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(18),
          border: graphite && !primary ? Border.all(color: tokens.lineStrong) : null,
        ),
        child: Text(label, style: tokens.ts(13, graphite ? FontWeight.w500 : FontWeight.w800, foreground)),
      ),
    );
  }
}
