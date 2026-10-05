import 'package:depenses/layers/technical/Theme/app_icon.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

class SimulationsComparisonInsight extends StatelessWidget {
  const SimulationsComparisonInsight(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: tokens.isGraphite
          ? Text(text, style: tokens.ts(16, FontWeight.w300, tokens.body).copyWith(height: 1.5))
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppIcon('bulb', size: 18, color: tokens.mint),
                const SizedBox(width: 10),
                Expanded(child: Text(text, style: tokens.ts(13, FontWeight.w500).copyWith(height: 1.45))),
              ],
            ),
    );
  }
}
