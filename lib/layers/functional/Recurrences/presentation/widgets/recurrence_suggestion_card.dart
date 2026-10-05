import 'package:depenses/layers/functional/Categories/domain/entities/category.dart';
import 'package:depenses/layers/functional/Categories/domain/entities/merchant_look.dart';
import 'package:depenses/layers/functional/Recurrences/domain/entities/recurring_suggestion.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import 'recurrence_suggestion_actions.dart';
import 'recurrence_suggestion_text.dart';
import 'recurrences_category_badge.dart';

class RecurrenceSuggestionCard extends StatelessWidget {
  const RecurrenceSuggestionCard({super.key, required this.suggestion, required this.look, required this.category});

  final RecurringSuggestion suggestion;
  final MerchantLook look;
  final Category category;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isGraphite = tokens.isGraphite;
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RecurrencesCategoryBadge(look: look, category: category, size: isGraphite ? 38 : 32, dashed: true),
            SizedBox(width: isGraphite ? 14 : 10),
            Expanded(child: RecurrenceSuggestionText(suggestion: suggestion)),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: isGraphite ? 52 : 42, top: 10),
          child: RecurrenceSuggestionActions(suggestion: suggestion),
        ),
      ],
    );
    if (isGraphite) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        decoration: BoxDecoration(
          border: Border.symmetric(horizontal: BorderSide(color: tokens.line)),
        ),
        child: content,
      );
    }
    return Container(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 14, AppSpacing.lg, 14),
      decoration: BoxDecoration(color: tokens.mintSoft, borderRadius: BorderRadius.circular(18)),
      child: content,
    );
  }
}
