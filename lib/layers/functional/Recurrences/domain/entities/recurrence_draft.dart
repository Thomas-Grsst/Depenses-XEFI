import 'package:equatable/equatable.dart';

import 'frequency.dart';

class RecurrenceDraft extends Equatable {
  const RecurrenceDraft({
    required this.name,
    required this.amount,
    required this.categoryKey,
    required this.frequency,
    required this.start,
    this.labels = const [],
  });

  final String name;
  final double amount;
  final String categoryKey;
  final Frequency frequency;
  final DateTime start;
  final List<String> labels;

  @override
  List<Object?> get props => [name, amount, categoryKey, frequency, start, labels];
}
