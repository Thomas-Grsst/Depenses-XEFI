import 'package:equatable/equatable.dart';

import '../../domain/entities/hypothesis_badges.dart';
import '../../domain/entities/scenario.dart';
import '../../domain/entities/scenario_comparison.dart';
import '../../domain/entities/simulation_baseline.dart';

enum SimulationsStatus { initial, ready }

class SimulationsState extends Equatable {
  const SimulationsState({
    this.status = SimulationsStatus.initial,
    this.scenarios = const [],
    this.pickedIds = const [],
    this.baseline,
    this.comparison,
    this.badges = const HypothesisBadges(),
  });

  final SimulationsStatus status;
  final List<Scenario> scenarios;
  final List<String> pickedIds;
  final SimulationBaseline? baseline;
  final ScenarioComparison? comparison;
  final HypothesisBadges badges;

  bool get hasScenarios => scenarios.isNotEmpty;

  SimulationsState copyWith({
    SimulationsStatus? status,
    List<Scenario>? scenarios,
    List<String>? pickedIds,
    SimulationBaseline? baseline,
    ScenarioComparison? comparison,
    HypothesisBadges? badges,
  }) => SimulationsState(
    status: status ?? this.status,
    scenarios: scenarios ?? this.scenarios,
    pickedIds: pickedIds ?? this.pickedIds,
    baseline: baseline ?? this.baseline,
    comparison: comparison ?? this.comparison,
    badges: badges ?? this.badges,
  );

  @override
  List<Object?> get props => [status, scenarios, pickedIds, baseline, comparison, badges];
}
