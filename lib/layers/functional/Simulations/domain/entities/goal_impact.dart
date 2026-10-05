import 'package:equatable/equatable.dart';

const _unreachableMonths = 999;

class GoalImpact extends Equatable {
  const GoalImpact({
    required this.goalName,
    required this.remaining,
    required this.monthsBefore,
    required this.monthsAfter,
  });

  final String goalName;
  final double remaining;
  final int? monthsBefore;
  final int? monthsAfter;

  int get monthDifference => (monthsAfter ?? _unreachableMonths) - (monthsBefore ?? _unreachableMonths);

  bool get isUnchanged => monthDifference == 0;

  bool get isReachabilityChanged => monthsBefore == null || monthsAfter == null;

  bool get isBlocked => monthsAfter == null;

  @override
  List<Object?> get props => [goalName, remaining, monthsBefore, monthsAfter];
}
