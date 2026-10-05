import 'package:depenses/layers/functional/Recurrences/domain/entities/frequency.dart';
import 'package:equatable/equatable.dart';

class Hypothesis extends Equatable {
  const Hypothesis({
    this.recurrenceId,
    required this.name,
    required this.categoryKey,
    required this.frequency,
    required this.oldAmount,
    required this.newAmount,
    this.isKept = true,
  });

  final String? recurrenceId;
  final String name;
  final String categoryKey;
  final Frequency frequency;
  final double oldAmount;
  final double newAmount;
  final bool isKept;

  bool get isNew => recurrenceId == null;

  double get effectiveAmount => isKept ? newAmount : 0;

  double get monthlyDelta => frequency.monthlyAmount(effectiveAmount) - frequency.monthlyAmount(oldAmount);

  Hypothesis copyWith({
    String? name,
    String? categoryKey,
    Frequency? frequency,
    double? oldAmount,
    double? newAmount,
    bool? isKept,
  }) => Hypothesis(
    recurrenceId: recurrenceId,
    name: name ?? this.name,
    categoryKey: categoryKey ?? this.categoryKey,
    frequency: frequency ?? this.frequency,
    oldAmount: oldAmount ?? this.oldAmount,
    newAmount: newAmount ?? this.newAmount,
    isKept: isKept ?? this.isKept,
  );

  @override
  List<Object?> get props => [recurrenceId, name, categoryKey, frequency, oldAmount, newAmount, isKept];
}
