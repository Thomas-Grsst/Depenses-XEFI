import 'package:depenses/layers/technical/Theme/app_pressable.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

class ExpenseFieldRow extends StatelessWidget {
  const ExpenseFieldRow({super.key, required this.label, required this.child, this.onTap, this.isLast = false});

  final String label;
  final Widget child;
  final VoidCallback? onTap;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isGraphite = tokens.isGraphite;
    final side = BorderSide(color: tokens.line);
    return AppPressable(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(minHeight: isGraphite ? 54 : 52),
        decoration: BoxDecoration(
          border: isGraphite
              ? Border(top: side, bottom: isLast ? side : BorderSide.none)
              : Border(bottom: isLast ? BorderSide.none : side),
        ),
        child: Row(
          children: [
            SizedBox(
              width: isGraphite ? 72 : 84,
              child: Text(
                isGraphite ? label.toUpperCase() : label,
                style: isGraphite ? tokens.label() : tokens.ts(13, FontWeight.w600, tokens.muted),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
