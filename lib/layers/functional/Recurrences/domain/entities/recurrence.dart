import 'dart:math';

import 'package:depenses/layers/technical/Calendar/calendar_day.dart';
import 'package:equatable/equatable.dart';

import 'frequency.dart';

const _maxOccurrencesScanned = 5000;

class Recurrence extends Equatable {
  const Recurrence({
    required this.id,
    required this.name,
    required this.amount,
    required this.categoryKey,
    required this.frequency,
    required this.start,
    this.labels = const [],
    this.lastGeneratedOn,
  });

  final String id;
  final String name;
  final double amount;
  final String categoryKey;
  final Frequency frequency;
  final DateTime start;
  final List<String> labels;
  final DateTime? lastGeneratedOn;

  double get monthlyAmount => frequency.monthlyAmount(amount);

  Iterable<DateTime> occurrences(DateTime from, DateTime to) sync* {
    for (var index = 0; index < _maxOccurrencesScanned; index++) {
      final date = _occurrenceAt(index);
      if (date.isAfter(to)) return;
      if (!date.isBefore(from)) yield date;
    }
  }

  DateTime? nextAfter(DateTime day) {
    final horizon = DateTime(day.year + 2, 12, 31);
    for (final date in occurrences(day.nextDay, horizon)) {
      return date;
    }
    return null;
  }

  DateTime _occurrenceAt(int index) {
    switch (frequency) {
      case Frequency.week:
        return DateTime(start.year, start.month, start.day + 7 * index);
      case Frequency.year:
        final year = start.year + index;
        return DateTime(year, start.month, min(start.day, daysInMonth(year, start.month)));
      case Frequency.month:
        final month = DateTime(start.year, start.month + index);
        return DateTime(month.year, month.month, min(start.day, month.daysInItsMonth));
    }
  }

  Recurrence copyWith({
    String? name,
    double? amount,
    String? categoryKey,
    Frequency? frequency,
    DateTime? start,
    List<String>? labels,
    DateTime? lastGeneratedOn,
  }) => Recurrence(
    id: id,
    name: name ?? this.name,
    amount: amount ?? this.amount,
    categoryKey: categoryKey ?? this.categoryKey,
    frequency: frequency ?? this.frequency,
    start: start ?? this.start,
    labels: labels ?? this.labels,
    lastGeneratedOn: lastGeneratedOn ?? this.lastGeneratedOn,
  );

  @override
  List<Object?> get props => [id, name, amount, categoryKey, frequency, start, labels, lastGeneratedOn];
}
