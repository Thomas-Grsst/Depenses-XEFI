import 'package:equatable/equatable.dart';

import '../../domain/entities/goal.dart';

enum SavingsGoalsStatus { loading, ready }

class SavingsGoalsState extends Equatable {
  const SavingsGoalsState({this.status = SavingsGoalsStatus.loading, this.goals = const [], this.today});

  final SavingsGoalsStatus status;
  final List<Goal> goals;
  final DateTime? today;

  SavingsGoalsState copyWith({SavingsGoalsStatus? status, List<Goal>? goals, DateTime? today}) =>
      SavingsGoalsState(status: status ?? this.status, goals: goals ?? this.goals, today: today ?? this.today);

  @override
  List<Object?> get props => [status, goals, today];
}
