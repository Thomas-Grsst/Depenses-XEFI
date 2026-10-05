import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

class ForecastBasisChip extends StatelessWidget {
  const ForecastBasisChip(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: tokens.card, borderRadius: BorderRadius.circular(999)),
      child: Text(label, style: tokens.ts(12, FontWeight.w700)),
    );
  }
}
