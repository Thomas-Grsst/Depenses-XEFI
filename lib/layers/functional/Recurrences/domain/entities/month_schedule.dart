import 'package:depenses/layers/technical/Calendar/calendar_day.dart';
import 'package:equatable/equatable.dart';

import 'schedule_entry.dart';

class MonthSchedule extends Equatable {
  const MonthSchedule({
    required this.today,
    required this.month,
    required this.entriesByDay,
    required this.plannedTotal,
  });

  final DateTime today;
  final DateTime month;
  final Map<int, List<ScheduleEntry>> entriesByDay;
  final double plannedTotal;

  int get daysInMonth => month.daysInItsMonth;

  bool get isOver => month.lastOfMonth.isBefore(today);

  bool get isCurrentYear => month.year == today.year;

  List<ScheduleEntry> entriesOn(int day) => entriesByDay[day] ?? const [];

  @override
  List<Object?> get props => [today, month, entriesByDay, plannedTotal];
}
