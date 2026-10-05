import 'package:flutter/material.dart';

import 'app_empty_row.dart';
import 'app_panel.dart';
import 'app_ruled.dart';
import 'app_spacing.dart';
import 'app_text_link.dart';
import 'app_tokens_context.dart';

class AppListSection extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;
  final List<Widget> children;
  final String? empty;
  final bool closed;

  const AppListSection({
    super.key,
    required this.title,
    this.action,
    this.onAction,
    required this.children,
    this.empty,
    this.closed = false,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final rows = children.isEmpty && empty != null ? [AppEmptyRow(empty!)] : children;
    final header = _AppListSectionHeader(title: title, action: action, onAction: onAction);
    if (tokens.isGraphite) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(padding: const EdgeInsets.only(bottom: 6), child: header),
          for (var i = 0; i < rows.length; i++) AppRuled(bottom: closed && i == rows.length - 1, child: rows[i]),
        ],
      );
    }
    return AppPanel(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: header,
          ),
          for (final row in rows) AppRuled(child: row),
        ],
      ),
    );
  }
}

class _AppListSectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;

  const _AppListSectionHeader({required this.title, this.action, this.onAction});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Row(
      children: [
        Expanded(
          child: tokens.isGraphite
              ? Text(title.toUpperCase(), style: tokens.label())
              : Text(title, style: tokens.ts(15, FontWeight.w800)),
        ),
        if (action != null && onAction != null) AppTextLink(action!, onTap: onAction!),
      ],
    );
  }
}
