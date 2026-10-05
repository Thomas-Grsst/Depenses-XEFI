import 'package:flutter/material.dart';

import 'app_pressable.dart';
import 'app_tokens_context.dart';

class AppPillChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final bool dashed;
  final bool expand;
  final double height;

  const AppPillChip(this.label, {super.key, this.selected = false, this.onTap, this.expand = false, this.height = 36})
    : dashed = false;

  const AppPillChip.dashed(this.label, {super.key, this.onTap, this.expand = false, this.height = 36})
    : selected = false,
      dashed = true;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final graphite = tokens.isGraphite;
    final Color background, foreground, border;
    if (graphite) {
      background = selected ? tokens.fab : Colors.transparent;
      foreground = selected ? tokens.fabInk : (dashed ? tokens.muted : tokens.ink);
      border = selected ? tokens.fab : tokens.lineStrong;
    } else {
      background = dashed ? Colors.transparent : (selected ? tokens.mintSoft : tokens.card);
      foreground = selected ? tokens.mint : tokens.muted;
      border = dashed ? tokens.muted : Colors.transparent;
    }
    final text = !graphite && selected && !dashed ? '✓ $label' : label;
    return AppPressable(
      onTap: onTap,
      child: Container(
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: expand ? Alignment.center : null,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(graphite ? height / 2 : 999),
          border: Border.all(color: border, width: dashed && !graphite ? 1.5 : 1),
        ),
        child: Align(
          widthFactor: expand ? null : 1,
          child: Text(text, style: tokens.ts(13, graphite ? FontWeight.w400 : FontWeight.w700, foreground)),
        ),
      ),
    );
  }
}
