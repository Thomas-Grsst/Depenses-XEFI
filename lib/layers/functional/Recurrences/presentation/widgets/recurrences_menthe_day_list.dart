import 'package:depenses/layers/functional/Recurrences/domain/entities/schedule_entry.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_panel.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../cubit/day_timing.dart';
import '../cubit/merchant_badges.dart';
import '../l10n/recurrences_day_labels.dart';
import '../l10n/recurrences_locale.dart';
import 'recurrences_day_tag.dart';
import 'recurrences_schedule_entry_row.dart';

class RecurrencesMentheDayList extends StatelessWidget {
  const RecurrencesMentheDayList({
    super.key,
    required this.day,
    required this.timing,
    required this.entries,
    required this.badges,
  });

  final DateTime? day;
  final DayTiming? timing;
  final List<ScheduleEntry> entries;
  final MerchantBadges badges;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final dayTiming = timing;
    return AppPanel(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 14, AppSpacing.lg, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(context.selectedDayTitle(day, isShort: false), style: tokens.ts(15, FontWeight.w800)),
              ),
              if (dayTiming != null) RecurrencesDayTag(timing: dayTiming),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          if (entries.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, AppSpacing.md),
              child: Text(
                context.tr(RecurrencesLocale.nothingThatDay),
                style: tokens.ts(14, FontWeight.w500, tokens.muted),
              ),
            ),
          for (final entry in entries)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 9),
              child: RecurrencesScheduleEntryRow(entry: entry, badges: badges, badgeSize: 36),
            ),
        ],
      ),
    );
  }
}
