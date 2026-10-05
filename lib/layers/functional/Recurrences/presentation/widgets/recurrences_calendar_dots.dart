import 'package:depenses/layers/functional/Categories/domain/entities/category.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

const _maxColoredDots = 3;

class RecurrencesCalendarDots extends StatelessWidget {
  const RecurrencesCalendarDots.single({super.key, required this.hasEntries, required this.isPast})
    : categories = const [];

  const RecurrencesCalendarDots.colored({super.key, required this.categories}) : hasEntries = false, isPast = false;

  final List<Category> categories;
  final bool hasEntries;
  final bool isPast;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    if (tokens.isGraphite) {
      return Container(
        width: 4,
        height: 4,
        decoration: BoxDecoration(
          color: hasEntries ? (isPast ? tokens.faint : tokens.ink) : Colors.transparent,
          shape: BoxShape.circle,
        ),
      );
    }
    return SizedBox(
      height: 6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (final category in categories.take(_maxColoredDots))
            Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 1),
              decoration: BoxDecoration(color: tokens.swatch(category.colorIndex), shape: BoxShape.circle),
            ),
        ],
      ),
    );
  }
}
