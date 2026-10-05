import 'package:depenses/layers/functional/Recurrences/domain/entities/recurring_suggestion.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../l10n/recurrences_locale.dart';

class RecurrenceSuggestionText extends StatelessWidget {
  const RecurrenceSuggestionText({super.key, required this.suggestion});

  final RecurringSuggestion suggestion;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isGraphite = tokens.isGraphite;
    final headline = context.trWith(RecurrencesLocale.suggestionHeadline, [
      suggestion.name,
      context.money.euros(suggestion.amount),
    ]);
    final sentence = context.trWith(
      isGraphite ? RecurrencesLocale.suggestionSentenceShort : RecurrencesLocale.suggestionSentence,
      [headline, suggestion.months],
    );
    final headlineStart = sentence.indexOf(headline);
    final isHeadlineBold = !isGraphite && headlineStart >= 0;
    return Text.rich(
      TextSpan(
        children: isHeadlineBold
            ? [
                TextSpan(text: sentence.substring(0, headlineStart)),
                TextSpan(
                  text: headline,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                TextSpan(text: sentence.substring(headlineStart + headline.length)),
              ]
            : [TextSpan(text: sentence)],
      ),
      style: tokens.ts(14, tokens.wBody, isGraphite ? tokens.body : tokens.ink).copyWith(height: 1.45),
    );
  }
}
