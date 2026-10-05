import 'package:depenses/layers/functional/Recurrences/domain/entities/month_schedule.dart';
import 'package:depenses/layers/technical/Localization/capitalize.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import 'recurrences_month_nav_button.dart';

class RecurrencesCalendarTitleRow extends StatelessWidget {
  const RecurrencesCalendarTitleRow({super.key, required this.schedule});

  final MonthSchedule schedule;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isGraphite = tokens.isGraphite;
    final month = schedule.month;
    final title = isGraphite && schedule.isCurrentYear
        ? capitalize(context.dates.monthName(month))
        : context.dates.monthYear(month);
    return Row(
      children: [
        const RecurrencesMonthNavButton.previous(),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: isGraphite
                ? tokens.ts(30, FontWeight.w300).copyWith(letterSpacing: -0.6)
                : tokens.ts(17, FontWeight.w800),
          ),
        ),
        const RecurrencesMonthNavButton.next(),
      ],
    );
  }
}
