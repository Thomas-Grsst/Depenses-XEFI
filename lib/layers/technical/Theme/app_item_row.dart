import 'package:flutter/material.dart';

import 'app_pressable.dart';
import 'app_spacing.dart';
import 'app_tokens_context.dart';

class AppItemRow extends StatelessWidget {
  final Widget? leading;
  final String title;
  final Widget? titleSuffix;
  final String? subtitle;
  final Widget? below;
  final String? trailing;
  final Widget? trailingWidget;
  final VoidCallback? onTap;

  const AppItemRow({
    super.key,
    this.leading,
    required this.title,
    this.titleSuffix,
    this.subtitle,
    this.below,
    this.trailing,
    this.trailingWidget,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final graphite = tokens.isGraphite;
    return AppPressable(
      onTap: onTap,
      child: Row(
        children: [
          if (leading != null) ...[leading!, SizedBox(width: graphite ? 14 : AppSpacing.md)],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        style: tokens.ts(15, graphite ? FontWeight.w400 : FontWeight.w600),
                      ),
                    ),
                    if (titleSuffix != null) ...[const SizedBox(width: 6), titleSuffix!],
                  ],
                ),
                if (subtitle != null && subtitle!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.xxs),
                    child: Text(
                      subtitle!,
                      overflow: TextOverflow.ellipsis,
                      style: tokens.ts(12, tokens.wSemi, tokens.muted),
                    ),
                  ),
                ?below,
              ],
            ),
          ),
          if (trailing != null)
            Padding(
              padding: const EdgeInsets.only(left: AppSpacing.sm),
              child: Text(trailing!, style: tokens.ts(15, graphite ? FontWeight.w400 : FontWeight.w700)),
            ),
          ?trailingWidget,
        ],
      ),
    );
  }
}
