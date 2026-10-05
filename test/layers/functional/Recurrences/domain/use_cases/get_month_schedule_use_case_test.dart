import 'package:depenses/layers/functional/Recurrences/domain/entities/schedule_entry.dart';
import 'package:depenses/layers/functional/Recurrences/domain/use_cases/get_month_schedule_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';

Map<String, dynamic> _expense(String id, String name, double amount, String date) => {
  'id': id,
  'name': name,
  'amount': amount,
  'date': date,
  'cat': 'ali',
  'labels': <String>[],
};

Map<String, dynamic> _monthly(String id, String name, double amount, String start) => {
  'id': id,
  'name': name,
  'amount': amount,
  'cat': 'log',
  'freq': 'month',
  'start': start,
  'labels': <String>[],
  'lastGen': '2026-10-15',
};

void main() {
  late TestDependencies dependencies;

  setUp(() {
    dependencies = TestDependencies(
      today: DateTime(2026, 10, 15),
      data: {
        'expenses': [_expense('a', 'Carrefour', 42, '2026-10-03'), _expense('b', 'Loyer', 800, '2026-10-05')],
        'recs': [_monthly('r1', 'Loyer', 800, '2026-01-05'), _monthly('r2', 'Netflix', 13.49, '2026-01-20')],
      },
    );
  });
  tearDown(() => dependencies.dispose());

  test('the current month mixes paid expenses with occurrences still to come', () {
    final schedule = dependencies.get<GetMonthScheduleUseCase>()();

    expect(schedule.month, DateTime(2026, 10));
    expect(schedule.today, DateTime(2026, 10, 15));
    expect(schedule.entriesOn(3), [
      const ScheduleEntry(name: 'Carrefour', categoryKey: 'ali', amount: 42, isPlanned: false),
    ]);
    expect(schedule.entriesOn(5).single.isPlanned, isFalse);
    expect(schedule.entriesOn(20), [
      const ScheduleEntry(name: 'Netflix', categoryKey: 'log', amount: 13.49, isPlanned: true),
    ]);
    expect(schedule.plannedTotal, 13.49);
    expect(schedule.isOver, isFalse);
  });

  test('a future month plans every occurrence from its first day', () {
    final schedule = dependencies.get<GetMonthScheduleUseCase>()(DateTime(2026, 11, 10));

    expect(schedule.month, DateTime(2026, 11));
    expect(schedule.entriesOn(5).single.isPlanned, isTrue);
    expect(schedule.plannedTotal, 813.49);
  });

  test('a past month has no planned occurrence and is over', () {
    final schedule = dependencies.get<GetMonthScheduleUseCase>()(DateTime(2026, 9));

    expect(schedule.plannedTotal, 0);
    expect(schedule.entriesByDay, isEmpty);
    expect(schedule.isOver, isTrue);
  });
}
