import 'package:flutter/material.dart';

import 'app_tokens_context.dart';

class AppConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;

  const AppConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
  });

  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    required String cancelLabel,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) =>
          AppConfirmDialog(title: title, message: message, confirmLabel: confirmLabel, cancelLabel: cancelLabel),
    );
    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final graphite = tokens.isGraphite;
    return AlertDialog(
      backgroundColor: tokens.sheet,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(graphite ? 16 : 24)),
      title: Text(title, style: tokens.ts(18, graphite ? FontWeight.w500 : FontWeight.w800)),
      content: Text(message, style: tokens.ts(14, tokens.wBody, tokens.muted)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(cancelLabel, style: tokens.ts(14, FontWeight.w600, tokens.muted)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(confirmLabel, style: tokens.ts(14, FontWeight.w700, tokens.warn)),
        ),
      ],
    );
  }
}
