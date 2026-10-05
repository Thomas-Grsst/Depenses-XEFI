import 'package:equatable/equatable.dart';

import 'simulation_trend.dart';

class SimulationResultLine extends Equatable {
  const SimulationResultLine({
    required this.label,
    required this.before,
    required this.after,
    required this.change,
    required this.trend,
  });

  final String label;
  final String before;
  final String after;
  final String change;
  final SimulationTrend trend;

  @override
  List<Object?> get props => [label, before, after, change, trend];
}
