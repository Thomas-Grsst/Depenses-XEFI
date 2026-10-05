import 'package:depenses/layers/functional/Recurrences/domain/entities/month_schedule.dart';
import 'package:depenses/layers/technical/Theme/app_panel.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../cubit/merchant_badges.dart';
import 'recurrences_calendar_grid.dart';
import 'recurrences_calendar_title_row.dart';
import 'recurrences_weekday_row.dart';

class RecurrencesCalendarPanel extends StatelessWidget {
  const RecurrencesCalendarPanel({super.key, required this.schedule, required this.selectedDay, required this.badges});

  final MonthSchedule schedule;
  final DateTime? selectedDay;
  final MerchantBadges badges;

  @override
  Widget build(BuildContext context) {
    final isGraphite = context.tokens.isGraphite;
    return AppPanel(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.lg, AppSpacing.md, AppSpacing.md),
      radius: 22,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isGraphite ? 0 : AppSpacing.xs),
            child: RecurrencesCalendarTitleRow(schedule: schedule),
          ),
          SizedBox(height: isGraphite ? 20 : 10),
          const RecurrencesWeekdayRow(),
          SizedBox(height: isGraphite ? 10 : 6),
          RecurrencesCalendarGrid(schedule: schedule, selectedDay: selectedDay, badges: badges),
        ],
      ),
    );
  }
}
