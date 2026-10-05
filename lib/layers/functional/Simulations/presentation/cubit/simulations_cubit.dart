import 'dart:async';

import 'package:depenses/layers/technical/Storage/ledger_changes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/hypothesis_badges.dart';
import '../../domain/entities/scenario.dart';
import '../../domain/entities/simulation_baseline.dart';
import '../../domain/use_cases/compare_scenarios_use_case.dart';
import '../../domain/use_cases/delete_scenario_use_case.dart';
import '../../domain/use_cases/describe_hypothesis_badges_use_case.dart';
import '../../domain/use_cases/get_scenarios_use_case.dart';
import '../../domain/use_cases/get_simulation_baseline_use_case.dart';
import 'simulations_state.dart';

const _maximumPicked = 2;

class SimulationsCubit extends Cubit<SimulationsState> {
  SimulationsCubit(
    this._getScenarios,
    this._getBaseline,
    this._compare,
    this._delete,
    this._describeBadges,
    LedgerChanges changes,
  ) : super(const SimulationsState()) {
    _subscription = changes.changes.listen((_) => load());
    load();
  }

  final GetScenariosUseCase _getScenarios;
  final GetSimulationBaselineUseCase _getBaseline;
  final CompareScenariosUseCase _compare;
  final DeleteScenarioUseCase _delete;
  final DescribeHypothesisBadgesUseCase _describeBadges;
  late final StreamSubscription<void> _subscription;

  void load() {
    final scenarios = _getScenarios();
    final picked = state.status == SimulationsStatus.initial
        ? scenarios.reversed.take(_maximumPicked).map((s) => s.id).toList().reversed.toList()
        : state.pickedIds.where((id) => scenarios.any((s) => s.id == id)).toList();
    _emitWith(_getBaseline(), scenarios, picked);
  }

  void toggle(String id) {
    final baseline = state.baseline;
    if (baseline == null) return;
    final picked = [...state.pickedIds];
    if (!picked.remove(id)) {
      picked.add(id);
      if (picked.length > _maximumPicked) picked.removeAt(0);
    }
    _emitWith(baseline, state.scenarios, picked);
  }

  Future<void> delete(String id) => _delete(id);

  void _emitWith(SimulationBaseline baseline, List<Scenario> scenarios, List<String> picked) => emit(
    state.copyWith(
      status: SimulationsStatus.ready,
      scenarios: scenarios,
      pickedIds: picked,
      baseline: baseline,
      comparison: _compare(baseline, scenarios, picked),
      badges: _describeBadges(scenarios.map(HypothesisBadges.leadKeyOf)),
    ),
  );

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
