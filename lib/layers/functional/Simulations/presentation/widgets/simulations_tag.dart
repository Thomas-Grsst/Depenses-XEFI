import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

class SimulationsTag extends StatelessWidget {
  const SimulationsTag(
    this.text, {
    super.key,
    this.color,
    this.background,
    this.weight = FontWeight.w700,
    this.padding = const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
  });

  final String text;
  final Color? color;
  final Color? background;
  final FontWeight weight;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      padding: padding,
      decoration: BoxDecoration(color: background ?? tokens.chip, borderRadius: BorderRadius.circular(999)),
      child: Text(text, style: tokens.ts(12, weight, color)),
    );
  }
}
