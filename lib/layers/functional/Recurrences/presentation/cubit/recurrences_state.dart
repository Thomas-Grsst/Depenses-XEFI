import 'package:depenses/layers/functional/Recurrences/domain/entities/month_schedule.dart';
import 'package:depenses/layers/functional/Recurrences/domain/entities/occurrence.dart';
import 'package:depenses/layers/functional/Recurrences/domain/entities/recurrence.dart';
import 'package:depenses/layers/functional/Recurrences/domain/entities/recurring_suggestion.dart';
import 'package:depenses/layers/functional/Recurrences/domain/entities/schedule_entry.dart';
import 'package:depenses/layers/technical/Calendar/calendar_day.dart';
import 'package:equatable/equatable.dart';

import 'day_timing.dart';
import 'merchant_badges.dart';
import 'recurrences_mode.dart';

class RecurrencesState extends Equatable {
  const RecurrencesState({
    this.mode = RecurrencesMode.list,
    this.recurrences = const [],
    this.nextOccurrences = const [],
    this.suggestions = const [],
    this.fixedMonthly = 0,
    this.currentSchedule,
    this.visibleSchedule,
    this.selectedDay,
    this.badges = const MerchantBadges(),
  });

  final RecurrencesMode mode;
  final List<Recurrence> recurrences;
  final List<Occurrence> nextOccurrences;
  final List<RecurringSuggestion> suggestions;
  final double fixedMonthly;
  final MonthSchedule? currentSchedule;
  final MonthSchedule? visibleSchedule;
  final DateTime? selectedDay;
  final MerchantBadges badges;

  bool get hasRecurrences => recurrences.isNotEmpty;

  RecurringSuggestion? get suggestion => suggestions.isEmpty ? null : suggestions.first;

  double get remainingThisMonth => currentSchedule?.plannedTotal ?? 0;

  DateTime? get selectedDayInView {
    final day = selectedDay;
    final month = visibleSchedule?.month;
    if (day == null || month == null) return null;
    return day.year == month.year && day.month == month.month ? day : null;
  }

  List<ScheduleEntry> get selectedEntries {
    final day = selectedDayInView;
    return day == null ? const [] : visibleSchedule!.entriesOn(day.day);
  }

  DayTiming? get selectedTiming {
    final day = selectedDayInView;
    final today = visibleSchedule?.today;
    if (day == null || today == null) return null;
    if (day.isSameDay(today)) return DayTiming.today;
    return day.isBefore(today) ? DayTiming.past : DayTiming.future;
  }

  RecurrencesState copyWith({
    RecurrencesMode? mode,
    List<Recurrence>? recurrences,
    List<Occurrence>? nextOccurrences,
    List<RecurringSuggestion>? suggestions,
    double? fixedMonthly,
    MonthSchedule? currentSchedule,
    MonthSchedule? visibleSchedule,
    DateTime? selectedDay,
    MerchantBadges? badges,
  }) => RecurrencesState(
    mode: mode ?? this.mode,
    recurrences: recurrences ?? this.recurrences,
    nextOccurrences: nextOccurrences ?? this.nextOccurrences,
    suggestions: suggestions ?? this.suggestions,
    fixedMonthly: fixedMonthly ?? this.fixedMonthly,
    currentSchedule: currentSchedule ?? this.currentSchedule,
    visibleSchedule: visibleSchedule ?? this.visibleSchedule,
    selectedDay: selectedDay ?? this.selectedDay,
    badges: badges ?? this.badges,
  );

  @override
  List<Object?> get props => [
    mode,
    recurrences,
    nextOccurrences,
    suggestions,
    fixedMonthly,
    currentSchedule,
    visibleSchedule,
    selectedDay,
    badges,
  ];
}
