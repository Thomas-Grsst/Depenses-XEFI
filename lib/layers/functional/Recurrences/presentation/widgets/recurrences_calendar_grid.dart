import 'package:depenses/layers/functional/Recurrences/domain/entities/month_schedule.dart';
import 'package:depenses/layers/technical/Calendar/calendar_day.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../cubit/merchant_badges.dart';
import 'recurrences_calendar_day_cell.dart';

class RecurrencesCalendarGrid extends StatelessWidget {
  const RecurrencesCalendarGrid({super.key, required this.schedule, required this.selectedDay, required this.badges});

  final MonthSchedule schedule;
  final DateTime? selectedDay;
  final MerchantBadges badges;

  @override
  Widget build(BuildContext context) {
    final emptyHeight = context.tokens.isGraphite ? 46.0 : 48.0;
    final lead = schedule.month.weekday - 1;
    final days = schedule.daysInMonth;
    final rowCount = ((lead + days) / DateTime.daysPerWeek).ceil();
    final selected = selectedDay;
    return Column(
      children: [
        for (var row = 0; row < rowCount; row++)
          Row(
            children: [
              for (var column = 0; column < DateTime.daysPerWeek; column++)
                Expanded(
                  child: switch (_dateAt(row * DateTime.daysPerWeek + column - lead + 1)) {
                    null => SizedBox(height: emptyHeight),
                    final date => RecurrencesCalendarDayCell(
                      date: date,
                      isSelected: selected != null && selected.isSameDay(date),
                      isToday: date.isSameDay(schedule.today),
                      isPast: date.isBefore(schedule.today),
                      dotCategories: [
                        for (final entry in schedule.entriesOn(date.day)) badges.categoryOf(entry.categoryKey),
                      ],
                    ),
                  },
                ),
            ],
          ),
      ],
    );
  }

  DateTime? _dateAt(int day) =>
      day < 1 || day > schedule.daysInMonth ? null : DateTime(schedule.month.year, schedule.month.month, day);
}
