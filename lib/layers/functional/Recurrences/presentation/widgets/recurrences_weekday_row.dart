import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../l10n/recurrences_day_labels.dart';

class RecurrencesWeekdayRow extends StatelessWidget {
  const RecurrencesWeekdayRow({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isGraphite = tokens.isGraphite;
    return Row(
      children: [
        for (final name in context.weekdayHeaders(isShort: isGraphite))
          Expanded(
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: isGraphite ? tokens.mono(10, tokens.faint) : tokens.ts(12, FontWeight.w700, tokens.muted),
            ),
          ),
      ],
    );
  }
}
