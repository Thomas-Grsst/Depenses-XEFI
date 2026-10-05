import 'package:equatable/equatable.dart';

class LabelUsage extends Equatable {
  const LabelUsage({required this.label, required this.expenseCount});

  final String label;
  final int expenseCount;

  @override
  List<Object?> get props => [label, expenseCount];
}
