import 'package:flutter/material.dart';

import 'app_panel.dart';
import 'app_spacing.dart';
import 'app_tokens_context.dart';

class AppSettingGroup extends StatelessWidget {
  final List<Widget> rows;

  const AppSettingGroup(this.rows, {super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final side = BorderSide(color: tokens.line);
    final last = rows.length - 1;
    if (tokens.isGraphite) {
      return Column(
        children: [
          for (var i = 0; i < rows.length; i++)
            Container(
              decoration: BoxDecoration(
                border: Border(top: side, bottom: i == last ? side : BorderSide.none),
              ),
              child: rows[i],
            ),
        ],
      );
    }
    return AppPanel(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++)
            Container(
              decoration: BoxDecoration(border: Border(bottom: i < last ? side : BorderSide.none)),
              child: rows[i],
            ),
        ],
      ),
    );
  }
}
