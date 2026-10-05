import 'dart:async';

import 'package:depenses/layers/functional/Recurrences/domain/entities/recurrence.dart';
import 'package:depenses/layers/technical/Storage/ledger_changes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/hypothesis.dart';
import '../../domain/entities/hypothesis_scale.dart';
import '../../domain/entities/scenario.dart';
import '../../domain/entities/simulation_baseline.dart';
import '../../domain/use_cases/compute_scenario_impact_use_case.dart';
import '../../domain/use_cases/describe_hypothesis_badges_use_case.dart';
import '../../domain/use_cases/get_scenarios_use_case.dart';
import '../../domain/use_cases/get_simulable_recurrences_use_case.dart';
import '../../domain/use_cases/get_simulation_baseline_use_case.dart';
import '../../domain/use_cases/hypothesize_new_charge_use_case.dart';
import '../../domain/use_cases/hypothesize_recurrence_change_use_case.dart';
import '../../domain/use_cases/save_scenario_use_case.dart';
import 'simulation_state.dart';

class SimulationCubit extends Cubit<SimulationState> {
  SimulationCubit(
    this._getBaseline,
    this._computeImpact,
    this._getSimulableRecurrences,
    this._hypothesizeRecurrenceChange,
    this._hypothesizeNewCharge,
    this._saveScenario,
    this._getScenarios,
    this._describeBadges,
    LedgerChanges changes,
  ) : super(const SimulationState()) {
    _subscription = changes.changes.listen((_) => _refresh(state.hypotheses));
  }

  final DescribeHypothesisBadgesUseCase _describeBadges;

  final GetSimulationBaselineUseCase _getBaseline;
  final ComputeScenarioImpactUseCase _computeImpact;
  final GetSimulableRecurrencesUseCase _getSimulableRecurrences;
  final HypothesizeRecurrenceChangeUseCase _hypothesizeRecurrenceChange;
  final HypothesizeNewChargeUseCase _hypothesizeNewCharge;
  final SaveScenarioUseCase _saveScenario;
  final GetScenariosUseCase _getScenarios;
  late final StreamSubscription<void> _subscription;
  SimulationBaseline? _baseline;

  void open(Scenario? source) {
    emit(SimulationState(status: SimulationStatus.editing, source: source));
    _refresh(source?.hypotheses ?? const []);
  }

  void reset() => _update(const []);

  void addRecurrence(Recurrence recurrence) => _update([...state.hypotheses, _hypothesizeRecurrenceChange(recurrence)]);

  void addNewCharge({required String name, required double? monthlyAmount, required String fallbackName}) {
    final hypothesis = _hypothesizeNewCharge(name: name, monthlyAmount: monthlyAmount, fallbackName: fallbackName);
    if (hypothesis != null) _update([...state.hypotheses, hypothesis]);
  }

  void remove(int index) => _update([...state.hypotheses]..removeAt(index));

  void step(int index, int direction) => _replace(index, (h) {
    if (!h.isKept) return h;
    return h.copyWith(newAmount: HypothesisScale.of(h).stepped(h.newAmount, direction));
  });

  void slide(int index, double amount) =>
      _replace(index, (h) => h.isKept ? h.copyWith(newAmount: HypothesisScale.of(h).snapped(amount)) : h);

  void keep(int index, bool isKept) => _replace(index, (h) => h.copyWith(isKept: isKept));

  Future<void> save({required String title, required String description, required String fallbackTitle}) async {
    await _saveScenario(
      title: title,
      description: description,
      fallbackTitle: fallbackTitle,
      hypotheses: state.hypotheses,
    );
    emit(state.copyWith(status: SimulationStatus.saved));
  }

  void _replace(int index, Hypothesis Function(Hypothesis) change) => _update([
    for (var i = 0; i < state.hypotheses.length; i++) i == index ? change(state.hypotheses[i]) : state.hypotheses[i],
  ]);

  void _refresh(List<Hypothesis> hypotheses) {
    if (state.status == SimulationStatus.initial) return;
    _baseline = _getBaseline();
    _update(hypotheses);
  }

  void _update(List<Hypothesis> hypotheses) {
    final baseline = _baseline;
    if (baseline == null) return;
    final usedIds = {for (final h in hypotheses) ?h.recurrenceId};
    final available = _getSimulableRecurrences(usedIds);
    emit(
      state.copyWith(
        hypotheses: hypotheses,
        impact: _computeImpact(baseline, hypotheses),
        availableRecurrences: available,
        hasRecurrences: available.isNotEmpty || _getSimulableRecurrences(const {}).isNotEmpty,
        scenarioCount: _getScenarios().length,
        badges: _describeBadges([
          for (final h in hypotheses) (h.name, h.categoryKey),
          for (final r in available) (r.name, r.categoryKey),
        ]),
      ),
    );
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
