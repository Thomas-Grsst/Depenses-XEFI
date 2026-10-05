import 'package:equatable/equatable.dart';

import 'compared_scenario.dart';
import 'comparison_metric.dart';

const _negligibleAmount = 0.005;

class ScenarioComparison extends Equatable {
  const ScenarioComparison({required this.today, this.picked = const [], this.metrics = const [], this.goalName});

  final DateTime today;
  final List<ComparedScenario> picked;
  final List<ComparisonMetric> metrics;
  final String? goalName;

  ComparedScenario get cheaper => picked.first.monthlyDelta <= picked.last.monthlyDelta ? picked.first : picked.last;

  ComparedScenario get pricier => cheaper == picked.first ? picked.last : picked.first;

  double get difference => (picked.first.monthlyDelta - picked.last.monthlyDelta).abs();

  bool get haveSameImpact => difference < _negligibleAmount;

  @override
  List<Object?> get props => [today, picked, metrics, goalName];
}
