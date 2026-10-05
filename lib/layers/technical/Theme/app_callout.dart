import 'package:flutter/material.dart';

import 'app_icon.dart';
import 'app_spacing.dart';
import 'app_tokens_context.dart';

class AppCallout extends StatelessWidget {
  final List<(String, bool)> parts;
  final String icon;
  final bool warn;
  final Widget? footer;

  const AppCallout.tip({super.key, required this.parts, this.icon = 'bulb', this.footer}) : warn = false;

  const AppCallout.warning({super.key, required this.parts, this.icon = 'alert', this.footer}) : warn = true;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final text = _AppCalloutText(parts: parts);
    if (tokens.isGraphite) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm, right: AppSpacing.md),
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(color: warn ? tokens.accent : tokens.mint, shape: BoxShape.circle),
                ),
              ),
              Expanded(child: text),
            ],
          ),
          if (footer != null) Padding(padding: const EdgeInsets.only(left: 18, top: 10), child: footer),
        ],
      );
    }
    return Container(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 14, AppSpacing.lg, 14),
      decoration: BoxDecoration(
        color: warn ? tokens.warnSoft : tokens.mintSoft,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 1, right: AppSpacing.md),
                child: AppIcon(icon, size: 20, color: warn ? tokens.warn : tokens.mint),
              ),
              Expanded(child: text),
            ],
          ),
          if (footer != null) Padding(padding: const EdgeInsets.only(left: 32, top: 10), child: footer),
        ],
      ),
    );
  }
}

class _AppCalloutText extends StatelessWidget {
  final List<(String, bool)> parts;

  const _AppCalloutText({required this.parts});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final graphite = tokens.isGraphite;
    final emphasis = TextStyle(
      fontWeight: graphite ? FontWeight.w400 : FontWeight.w800,
      color: graphite ? tokens.ink : null,
    );
    return Text.rich(
      TextSpan(
        children: [for (final part in parts) TextSpan(text: part.$1, style: part.$2 ? emphasis : null)],
      ),
      style: tokens.ts(graphite ? 15 : 14, tokens.wBody, graphite ? tokens.body : tokens.ink).copyWith(height: 1.45),
    );
  }
}
