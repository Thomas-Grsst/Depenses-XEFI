import 'package:equatable/equatable.dart';

class Expense extends Equatable {
  const Expense({
    required this.id,
    required this.name,
    required this.amount,
    required this.date,
    required this.categoryKey,
    this.labels = const [],
    this.recurrenceId,
    this.roundUp = 0,
  });

  final String id;
  final String name;
  final double amount;
  final DateTime date;
  final String categoryKey;
  final List<String> labels;
  final String? recurrenceId;
  final double roundUp;

  bool get isRecurring => recurrenceId != null;

  double get debited => amount + roundUp;

  Expense copyWith({
    String? name,
    double? amount,
    DateTime? date,
    String? categoryKey,
    List<String>? labels,
    String? Function()? recurrenceId,
    double? roundUp,
  }) => Expense(
    id: id,
    name: name ?? this.name,
    amount: amount ?? this.amount,
    date: date ?? this.date,
    categoryKey: categoryKey ?? this.categoryKey,
    labels: labels ?? this.labels,
    recurrenceId: recurrenceId == null ? this.recurrenceId : recurrenceId(),
    roundUp: roundUp ?? this.roundUp,
  );

  @override
  List<Object?> get props => [id, name, amount, date, categoryKey, labels, recurrenceId, roundUp];
}
