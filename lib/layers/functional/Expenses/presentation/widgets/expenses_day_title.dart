import 'package:depenses/layers/technical/Calendar/calendar_day.dart';
import 'package:depenses/layers/technical/Localization/date_labels.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

class ExpensesDayTitle extends StatelessWidget {
  const ExpensesDayTitle({super.key, required this.day, required this.today});

  final DateTime day;
  final DateTime today;

  String _graphiteTitle(DateLabels dates) {
    if (day.isSameDay(today)) return dates.words.today.toUpperCase();
    final base = '${dates.dayNumber(day)} ${dates.shortMonthName(day)}';
    if (day.isSameDay(today.previousDay)) return dates.words.yesterdayWith(base).toUpperCase();
    return '${dates.shortWeekday(day)} $base'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final dates = context.dates;
    if (tokens.isGraphite) return Text(_graphiteTitle(dates), style: tokens.label());
    return Text(dates.dayHeader(day, today: today), style: tokens.ts(13, FontWeight.w700, tokens.muted));
  }
}
