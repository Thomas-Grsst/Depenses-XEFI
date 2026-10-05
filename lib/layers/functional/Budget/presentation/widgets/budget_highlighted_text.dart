import 'package:flutter/material.dart';

class BudgetHighlightedText extends StatelessWidget {
  const BudgetHighlightedText({
    super.key,
    required this.sentence,
    required this.highlight,
    required this.highlightStyle,
    required this.style,
    this.textAlign,
  });

  final String sentence;
  final String highlight;
  final TextStyle highlightStyle;
  final TextStyle style;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final start = sentence.lastIndexOf(highlight);
    return Text.rich(
      TextSpan(
        children: start < 0
            ? [TextSpan(text: sentence)]
            : [
                TextSpan(text: sentence.substring(0, start)),
                TextSpan(text: highlight, style: highlightStyle),
                TextSpan(text: sentence.substring(start + highlight.length)),
              ],
      ),
      textAlign: textAlign,
      style: style,
    );
  }
}
