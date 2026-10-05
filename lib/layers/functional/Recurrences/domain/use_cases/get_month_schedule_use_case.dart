import 'package:depenses/layers/functional/Expenses/domain/gateways/expense_gateway.dart';
import 'package:depenses/layers/technical/Calendar/calendar_day.dart';
import 'package:depenses/layers/technical/Calendar/clock.dart';

import '../entities/month_schedule.dart';
import '../entities/occurrence.dart';
import '../entities/schedule_entry.dart';
import 'get_upcoming_occurrences_use_case.dart';

class GetMonthScheduleUseCase {
  GetMonthScheduleUseCase(this._expenses, this._upcoming, this._clock);

  final ExpenseGateway _expenses;
  final GetUpcomingOccurrencesUseCase _upcoming;
  final Clock _clock;

  MonthSchedule call([DateTime? month]) {
    final today = _clock.today();
    final first = (month ?? today).firstOfMonth;
    final entries = <int, List<ScheduleEntry>>{};
    void place(DateTime date, ScheduleEntry entry) => entries.putIfAbsent(date.day, () => []).add(entry);
    for (final expense in _expenses.inMonth(first)) {
      place(
        expense.date,
        ScheduleEntry(name: expense.name, categoryKey: expense.categoryKey, amount: expense.amount, isPlanned: false),
      );
    }
    final planned = _plannedOccurrences(first, today);
    for (final occurrence in planned) {
      final recurrence = occurrence.recurrence;
      place(
        occurrence.date,
        ScheduleEntry(
          name: recurrence.name,
          categoryKey: recurrence.categoryKey,
          amount: recurrence.amount,
          isPlanned: true,
        ),
      );
    }
    return MonthSchedule(
      today: today,
      month: first,
      entriesByDay: entries,
      plannedTotal: planned.fold(0.0, (total, o) => total + o.recurrence.amount),
    );
  }

  List<Occurrence> _plannedOccurrences(DateTime first, DateTime today) {
    final last = first.lastOfMonth;
    final from = first.isAfter(today) ? first : today.nextDay;
    return last.isBefore(from) ? const [] : _upcoming(from, last);
  }
}
