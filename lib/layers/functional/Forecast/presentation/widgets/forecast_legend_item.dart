import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

class ForecastLegendItem extends StatelessWidget {
  const ForecastLegendItem(this.label, this.color, {super.key, this.isSolid = false});

  final String label;
  final Color color;
  final bool isSolid;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 16,
          height: 3,
          child: isSolid
              ? ColoredBox(color: color)
              : Row(
                  children: [
                    for (var i = 0; i < 3; i++) ...[
                      Expanded(child: ColoredBox(color: color)),
                      if (i < 2) const SizedBox(width: 2),
                    ],
                  ],
                ),
        ),
        const SizedBox(width: 6),
        Text(
          tokens.isGraphite ? label.toUpperCase() : label,
          style: tokens.isGraphite ? tokens.mono(10, tokens.muted) : tokens.ts(12, FontWeight.w600, tokens.muted),
        ),
      ],
    );
  }
}
