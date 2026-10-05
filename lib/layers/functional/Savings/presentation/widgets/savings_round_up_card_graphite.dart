import 'package:depenses/layers/technical/Theme/app_icon.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

class SavingsRoundUpCardGraphite extends StatelessWidget {
  const SavingsRoundUpCardGraphite({super.key, required this.label, required this.amount, required this.details});

  final String label;
  final String amount;
  final String details;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      decoration: BoxDecoration(
        border: Border.symmetric(horizontal: BorderSide(color: tokens.line)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: tokens.lineStrong),
            ),
            child: AppIcon('piggy', size: 19, color: tokens.ink),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: tokens.label()),
                const SizedBox(height: AppSpacing.xs),
                if (details.isNotEmpty) Text(details, style: tokens.ts(12, FontWeight.w400, tokens.muted)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(amount, style: tokens.ts(17, FontWeight.w400, tokens.mint)),
        ],
      ),
    );
  }
}
