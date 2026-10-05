import 'package:depenses/layers/functional/Recurrences/domain/entities/schedule_entry.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_ruled.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../cubit/day_timing.dart';
import '../cubit/merchant_badges.dart';
import '../l10n/recurrences_day_labels.dart';
import '../l10n/recurrences_locale.dart';
import 'recurrences_menthe_day_list.dart';
import 'recurrences_schedule_entry_row.dart';

class RecurrencesDayList extends StatelessWidget {
  const RecurrencesDayList({
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
    if (!tokens.isGraphite) {
      return RecurrencesMentheDayList(day: day, timing: timing, entries: entries, badges: badges);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            children: [
              Expanded(child: Text(context.selectedDayTitle(day, isShort: true), style: tokens.label())),
              Text(context.dayTimingLabel(timing).toUpperCase(), style: tokens.label()),
            ],
          ),
        ),
        if (entries.isEmpty)
          AppRuled(
            child: Text(
              context.tr(RecurrencesLocale.nothingThatDayShort),
              style: tokens.ts(14, FontWeight.w400, tokens.muted),
            ),
          ),
        for (final entry in entries)
          AppRuled(
            child: RecurrencesScheduleEntryRow(entry: entry, badges: badges, badgeSize: 38),
          ),
      ],
    );
  }
}
