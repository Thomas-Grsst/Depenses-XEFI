import 'package:depenses/layers/technical/Theme/app_icon.dart';
import 'package:depenses/layers/technical/Theme/app_panel.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

class SavingsRoundUpCardMenthe extends StatelessWidget {
  const SavingsRoundUpCardMenthe({super.key, required this.label, required this.amount, required this.details});

  final String label;
  final String amount;
  final String details;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return AppPanel(
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: tokens.mintSoft, borderRadius: BorderRadius.circular(14)),
            child: AppIcon('piggy', size: 22, color: tokens.mint, stroke: 2),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: tokens.ts(13, FontWeight.w600, tokens.muted)),
                Text(amount, style: tokens.ts(20, FontWeight.w800, tokens.mint)),
                if (details.isNotEmpty)
                  Text(details, style: tokens.ts(12, FontWeight.w600, tokens.muted).copyWith(height: 1.35)),
              ],
            ),
          ),
          AppIcon('chevR', size: 18, color: tokens.muted),
        ],
      ),
    );
  }
}
