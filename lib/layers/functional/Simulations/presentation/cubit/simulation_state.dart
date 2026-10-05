import 'package:depenses/layers/functional/Recurrences/domain/entities/recurrence.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/hypothesis.dart';
import '../../domain/entities/hypothesis_badges.dart';
import '../../domain/entities/scenario.dart';
import '../../domain/entities/scenario_impact.dart';

enum SimulationStatus { initial, editing, saved }

class SimulationState extends Equatable {
  const SimulationState({
    this.status = SimulationStatus.initial,
    this.source,
    this.hypotheses = const [],
    this.impact,
    this.availableRecurrences = const [],
    this.hasRecurrences = false,
    this.scenarioCount = 0,
    this.badges = const HypothesisBadges(),
  });

  final SimulationStatus status;
  final Scenario? source;
  final List<Hypothesis> hypotheses;
  final ScenarioImpact? impact;
  final List<Recurrence> availableRecurrences;
  final bool hasRecurrences;
  final int scenarioCount;
  final HypothesisBadges badges;

  bool get hasHypotheses => hypotheses.isNotEmpty;

  SimulationState copyWith({
    SimulationStatus? status,
    List<Hypothesis>? hypotheses,
    ScenarioImpact? impact,
    List<Recurrence>? availableRecurrences,
    bool? hasRecurrences,
    int? scenarioCount,
    HypothesisBadges? badges,
  }) => SimulationState(
    status: status ?? this.status,
    source: source,
    hypotheses: hypotheses ?? this.hypotheses,
    impact: impact ?? this.impact,
    availableRecurrences: availableRecurrences ?? this.availableRecurrences,
    hasRecurrences: hasRecurrences ?? this.hasRecurrences,
    scenarioCount: scenarioCount ?? this.scenarioCount,
    badges: badges ?? this.badges,
  );

  @override
  List<Object?> get props => [
    status,
    source,
    hypotheses,
    impact,
    availableRecurrences,
    hasRecurrences,
    scenarioCount,
    badges,
  ];
}
