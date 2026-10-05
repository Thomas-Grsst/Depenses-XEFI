import 'package:equatable/equatable.dart';

import 'scenario.dart';

class ComparedScenario extends Equatable {
  const ComparedScenario({required this.position, required this.scenario});

  final int position;
  final Scenario scenario;

  double get monthlyDelta => scenario.monthlyDelta;

  @override
  List<Object?> get props => [position, scenario];
}
