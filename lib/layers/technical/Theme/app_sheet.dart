import 'package:flutter/material.dart';

import 'app_icon.dart';
import 'app_pressable.dart';
import 'app_spacing.dart';
import 'app_tokens_context.dart';

class AppSheet extends StatelessWidget {
  final String title;
  final String closeLabel;
  final Widget child;

  const AppSheet({super.key, required this.title, required this.closeLabel, required this.child});

  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required String closeLabel,
    required WidgetBuilder builder,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: context.tokens.isGraphite ? const Color(0xB3000000) : const Color(0x80040C09),
      builder: (sheetContext) => AppSheet(title: title, closeLabel: closeLabel, child: builder(sheetContext)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final graphite = tokens.isGraphite;
    final media = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
      child: Container(
        constraints: BoxConstraints(maxHeight: media.size.height * 0.88),
        decoration: BoxDecoration(
          color: tokens.sheet,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: graphite ? Border(top: BorderSide(color: tokens.lineStrong)) : null,
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(tokens.pad, AppSpacing.md, tokens.pad, AppSpacing.xxl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: graphite ? tokens.lineStrong : tokens.off,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _AppSheetHeader(title: title, closeLabel: closeLabel),
                SizedBox(height: graphite ? 18 : 14),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AppSheetHeader extends StatelessWidget {
  final String title;
  final String closeLabel;

  const _AppSheetHeader({required this.title, required this.closeLabel});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final graphite = tokens.isGraphite;
    return Row(
      children: [
        Expanded(child: Text(title, style: tokens.ts(18, graphite ? FontWeight.w500 : FontWeight.w800))),
        AppPressable(
          onTap: () => Navigator.of(context).pop(),
          semanticsLabel: closeLabel,
          child: Container(
            width: 40,
            height: 40,
            alignment: graphite ? Alignment.centerRight : Alignment.center,
            decoration: graphite ? null : BoxDecoration(color: tokens.chip, shape: BoxShape.circle),
            child: AppIcon('close', size: 18, color: tokens.ink),
          ),
        ),
      ],
    );
  }
}
