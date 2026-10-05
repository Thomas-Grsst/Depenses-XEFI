import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../cubit/day_timing.dart';
import '../l10n/recurrences_day_labels.dart';

class RecurrencesDayTag extends StatelessWidget {
  const RecurrencesDayTag({super.key, required this.timing});

  final DayTiming timing;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isPaid = timing == DayTiming.past;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: isPaid ? tokens.chip : tokens.mintSoft,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        context.dayTimingLabel(timing),
        style: tokens.ts(12, FontWeight.w700, isPaid ? tokens.muted : tokens.mint),
      ),
    );
  }
}
