import 'package:flutter/material.dart';

import 'app_spacing.dart';
import 'app_tokens_context.dart';

class AppBigAmount extends StatelessWidget {
  final String amount;
  final String currency;
  final String? suffix;
  final double size;
  final Color? color;

  const AppBigAmount(this.amount, {super.key, required this.currency, this.suffix, this.size = 40, this.color});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final textColor = color ?? tokens.ink;
    if (tokens.isGraphite) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                amount,
                style: tokens.ts(size, FontWeight.w300, textColor).copyWith(letterSpacing: -size * 0.04, height: 1),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(suffix ?? currency, style: tokens.ts(size * 0.36, FontWeight.w300, tokens.muted)),
        ],
      );
    }
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: '$amount $currency'),
            if (suffix != null)
              TextSpan(text: ' $suffix', style: tokens.ts(size * 0.45, FontWeight.w700, tokens.heroMuted)),
          ],
        ),
        style: tokens.ts(size, FontWeight.w800, textColor).copyWith(letterSpacing: -size * 0.02, height: 1.1),
      ),
    );
  }
}
