import 'package:flutter/material.dart';

import 'app_dashed_rounded_rect_painter.dart';
import 'app_icon.dart';
import 'app_pressable.dart';
import 'app_spacing.dart';
import 'app_tokens_context.dart';

enum _AppButtonVariant { primary, secondary, dashed }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final String? icon;
  final Color? color;
  final _AppButtonVariant _variant;

  const AppButton.primary(this.label, {super.key, this.onTap, this.icon})
    : color = null,
      _variant = _AppButtonVariant.primary;

  const AppButton.secondary(this.label, {super.key, this.onTap, this.color})
    : icon = null,
      _variant = _AppButtonVariant.secondary;

  const AppButton.dashed(this.label, {super.key, required VoidCallback this.onTap})
    : icon = null,
      color = null,
      _variant = _AppButtonVariant.dashed;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      child: switch (_variant) {
        _AppButtonVariant.primary => _AppPrimaryButtonBody(label: label, icon: icon, enabled: onTap != null),
        _AppButtonVariant.secondary => _AppSecondaryButtonBody(label: label, color: color),
        _AppButtonVariant.dashed => _AppDashedButtonBody(label: label),
      },
    );
  }
}

class _AppPrimaryButtonBody extends StatelessWidget {
  final String label;
  final String? icon;
  final bool enabled;

  const _AppPrimaryButtonBody({required this.label, required this.icon, required this.enabled});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final graphite = tokens.isGraphite;
    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: Container(
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: tokens.fab, borderRadius: BorderRadius.circular(graphite ? 28 : 18)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              AppIcon(icon!, size: 18, color: tokens.fabInk, stroke: 2),
              const SizedBox(width: AppSpacing.sm),
            ],
            Text(
              label,
              style: tokens.ts(graphite ? 15 : 16, graphite ? FontWeight.w500 : FontWeight.w800, tokens.fabInk),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppSecondaryButtonBody extends StatelessWidget {
  final String label;
  final Color? color;

  const _AppSecondaryButtonBody({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final graphite = tokens.isGraphite;
    return Container(
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: graphite ? Colors.transparent : tokens.card,
        borderRadius: BorderRadius.circular(graphite ? 28 : 18),
        border: graphite ? Border.all(color: tokens.lineStrong) : null,
      ),
      child: Text(label, style: tokens.ts(15, graphite ? FontWeight.w400 : FontWeight.w700, color ?? tokens.ink)),
    );
  }
}

class _AppDashedButtonBody extends StatelessWidget {
  final String label;

  const _AppDashedButtonBody({required this.label});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    if (tokens.isGraphite) {
      return SizedBox(
        height: 48,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(label, style: tokens.ts(14, FontWeight.w400, tokens.muted)),
        ),
      );
    }
    return CustomPaint(
      painter: AppDashedRoundedRectPainter(color: tokens.muted, radius: 16),
      child: Container(
        height: 48,
        alignment: Alignment.center,
        child: Text(label, style: tokens.ts(14, FontWeight.w700)),
      ),
    );
  }
}
