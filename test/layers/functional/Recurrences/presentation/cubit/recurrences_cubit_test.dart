import 'package:bloc_test/bloc_test.dart';
import 'package:depenses/layers/functional/Recurrences/domain/gateways/recurrence_gateway.dart';
import 'package:depenses/layers/functional/Recurrences/presentation/cubit/day_timing.dart';
import 'package:depenses/layers/functional/Recurrences/presentation/cubit/recurrences_cubit.dart';
import 'package:depenses/layers/functional/Recurrences/presentation/cubit/recurrences_mode.dart';
import 'package:depenses/layers/functional/Recurrences/presentation/cubit/recurrences_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';

Map<String, dynamic> _expense(String id, String name, double amount, String date) => {
  'id': id,
  'name': name,
  'amount': amount,
  'date': date,
  'cat': 'loi',
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
        'expenses': [
          _expense('a', 'Spotify', 10.99, '2026-08-03'),
          _expense('b', 'Spotify', 10.99, '2026-09-03'),
          _expense('c', 'Spotify', 10.99, '2026-10-03'),
        ],
        'recs': [_monthly('r1', 'Netflix', 13.49, '2026-01-20'), _monthly('r2', 'Loyer', 800, '2026-01-05')],
      },
    );
  });
  tearDown(() => dependencies.dispose());

  RecurrencesCubit build() => dependencies.get<RecurrencesCubit>();

  test('loading exposes recurrences, totals, suggestions and today as the selected day', () async {
    final cubit = build();
    final state = cubit.state;
    await cubit.close();

    expect([for (final r in state.recurrences) r.name], ['Loyer', 'Netflix']);
    expect(state.fixedMonthly, 813.49);
    expect(state.remainingThisMonth, 13.49);
    expect(state.nextOccurrences.first.recurrence.name, 'Netflix');
    expect(state.suggestion?.name, 'Spotify');
    expect(state.selectedDay, DateTime(2026, 10, 15));
    expect(state.selectedTiming, DayTiming.today);
    expect(state.badges.categoryOf('log').key, 'log');
    expect(state.badges.lookOf('Netflix', 'log').letter, 'N');
  });

  blocTest<RecurrencesCubit, RecurrencesState>(
    'switching to the calendar keeps the loaded data',
    build: build,
    act: (cubit) => cubit.showMode(RecurrencesMode.calendar),
    verify: (cubit) {
      expect(cubit.state.mode, RecurrencesMode.calendar);
      expect(cubit.state.hasRecurrences, isTrue);
    },
  );

  blocTest<RecurrencesCubit, RecurrencesState>(
    'selecting a past day lists what was paid that day',
    build: build,
    act: (cubit) => cubit.selectDay(DateTime(2026, 10, 3)),
    verify: (cubit) {
      expect(cubit.state.selectedTiming, DayTiming.past);
      expect(cubit.state.selectedEntries.single.name, 'Spotify');
    },
  );

  blocTest<RecurrencesCubit, RecurrencesState>(
    'shifting to the next month shows its planned occurrences and hides the selection',
    build: build,
    act: (cubit) => cubit.shiftMonth(1),
    verify: (cubit) {
      expect(cubit.state.visibleSchedule?.month, DateTime(2026, 11));
      expect(cubit.state.visibleSchedule?.plannedTotal, 813.49);
      expect(cubit.state.selectedDayInView, isNull);
      expect(cubit.state.selectedEntries, isEmpty);
      expect(cubit.state.remainingThisMonth, 13.49);
    },
  );

  test('accepting a suggestion reloads with the new recurrence and no suggestion', () async {
    final cubit = build();

    await cubit.acceptSuggestion(cubit.state.suggestion!);

    expect(cubit.state.suggestion, isNull);
    expect(cubit.state.recurrences, hasLength(3));
    expect(dependencies.get<RecurrenceGateway>().all(), hasLength(3));
    await cubit.close();
  });

  test('ignoring a suggestion removes it', () async {
    final cubit = build();

    await cubit.ignoreSuggestion(cubit.state.suggestion!);

    expect(cubit.state.suggestions, isEmpty);
    await cubit.close();
  });
}
