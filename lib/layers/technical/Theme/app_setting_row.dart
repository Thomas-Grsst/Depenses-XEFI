import 'package:flutter/material.dart';

import 'app_icon.dart';
import 'app_pressable.dart';
import 'app_tokens_context.dart';

class AppSettingRow extends StatelessWidget {
  final String label;
  final String? value;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool chevron;
  final Color? color;

  const AppSettingRow(this.label, {super.key, this.value, this.trailing, this.onTap, this.chevron = false, this.color});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final graphite = tokens.isGraphite;
    return AppPressable(
      onTap: onTap,
      child: SizedBox(
        height: graphite ? 56 : 52,
        child: Row(
          children: [
            Expanded(child: Text(label, style: tokens.ts(15, graphite ? FontWeight.w400 : FontWeight.w700, color))),
            if (value != null)
              Padding(
                padding: EdgeInsets.only(right: chevron ? 10 : 0),
                child: Text(
                  value!,
                  style: graphite ? tokens.mono(11, tokens.muted) : tokens.ts(15, FontWeight.w600, tokens.muted),
                ),
              ),
            ?trailing,
            if (chevron) AppIcon('chevR', size: 18, color: tokens.muted),
          ],
        ),
      ),
    );
  }
}
