import 'package:flutter/material.dart';

import 'app_icon.dart';
import 'app_tokens_context.dart';

class AppIconBadge extends StatelessWidget {
  final String? icon;
  final String? letter;
  final Color color;
  final double size;
  final bool selected;
  final bool dashed;

  const AppIconBadge({
    super.key,
    required String this.icon,
    required this.color,
    this.size = 40,
    this.selected = false,
    this.dashed = false,
  }) : letter = null;

  const AppIconBadge.letter({
    super.key,
    required String this.letter,
    required this.color,
    this.size = 40,
    this.selected = false,
    this.dashed = false,
  }) : icon = null;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final graphite = tokens.isGraphite;
    final Color foreground, background;
    final BoxBorder? border;
    if (graphite) {
      foreground = selected ? Colors.white : tokens.ink;
      background = selected ? tokens.fab : Colors.transparent;
      border = Border.all(color: selected ? tokens.fab : (dashed ? tokens.faint : tokens.lineStrong));
    } else {
      foreground = color;
      background = color.withValues(alpha: tokens.isDark ? 0.18 : 0.12);
      border = null;
    }
    final content = icon != null
        ? AppIcon(icon!, size: size * 0.5, color: foreground, stroke: graphite ? 1.4 : 2)
        : Text(
            letter!.isEmpty ? '?' : letter!,
            style: TextStyle(
              fontFamily: tokens.font,
              fontWeight: graphite ? FontWeight.w500 : FontWeight.w800,
              fontSize: size * 0.42,
              color: foreground,
              height: 1,
            ),
          );
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(graphite ? size / 2 : size * 0.32),
        border: border,
      ),
      child: content,
    );
  }
}
