import 'package:flutter/material.dart';

import 'app_spacing.dart';
import 'app_tokens_context.dart';

class AppPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? color;
  final double radius;
  final bool forceCard;

  const AppPanel({super.key, required this.child, this.padding, this.color, this.radius = 20, this.forceCard = false});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    if (tokens.isGraphite && !forceCard) return child;
    return Container(
      padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(color: color ?? tokens.card, borderRadius: BorderRadius.circular(radius)),
      child: child,
    );
  }
}
