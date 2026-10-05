import 'package:depenses/layers/functional/Recurrences/domain/entities/frequency.dart';
import 'package:depenses/layers/functional/Recurrences/domain/entities/recurrence.dart';
import 'package:flutter_test/flutter_test.dart';

Recurrence _recurrence(Frequency frequency, DateTime start) =>
    Recurrence(id: 'r', name: 'Loyer', amount: 120, categoryKey: 'log', frequency: frequency, start: start);

void main() {
  test('monthly occurrences are clamped to the last day of shorter months', () {
    final recurrence = _recurrence(Frequency.month, DateTime(2026, 1, 31));

    expect(recurrence.occurrences(DateTime(2026, 1, 1), DateTime(2026, 4, 30)).toList(), [
      DateTime(2026, 1, 31),
      DateTime(2026, 2, 28),
      DateTime(2026, 3, 31),
      DateTime(2026, 4, 30),
    ]);
  });

  test('weekly occurrences step seven days and respect the window start', () {
    final recurrence = _recurrence(Frequency.week, DateTime(2026, 10, 1));

    expect(recurrence.occurrences(DateTime(2026, 10, 5), DateTime(2026, 10, 22)).toList(), [
      DateTime(2026, 10, 8),
      DateTime(2026, 10, 15),
      DateTime(2026, 10, 22),
    ]);
  });

  test('yearly occurrence on february 29th falls back to february 28th', () {
    final recurrence = _recurrence(Frequency.year, DateTime(2028, 2, 29));

    expect(recurrence.occurrences(DateTime(2029, 1, 1), DateTime(2029, 12, 31)).single, DateTime(2029, 2, 28));
  });

  test('next occurrence after a day is strictly later', () {
    final recurrence = _recurrence(Frequency.month, DateTime(2026, 1, 15));

    expect(recurrence.nextAfter(DateTime(2026, 10, 15)), DateTime(2026, 11, 15));
  });

  test('monthly amount normalises weekly and yearly frequencies', () {
    expect(Frequency.week.monthlyAmount(12), closeTo(52, 0.001));
    expect(Frequency.year.monthlyAmount(120), 10);
    expect(Frequency.month.monthlyAmount(30), 30);
  });

  test('an unknown stored frequency is read as monthly', () {
    expect(Frequency.fromStorageKey('daily'), Frequency.month);
  });
}
