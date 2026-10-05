import 'dart:async';

import 'package:depenses/layers/technical/Calendar/clock.dart';
import 'package:depenses/layers/technical/Storage/ledger_changes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/goal.dart';
import '../../domain/use_cases/delete_goal_use_case.dart';
import '../../domain/use_cases/get_goals_use_case.dart';
import '../../domain/use_cases/save_goal_use_case.dart';
import 'savings_goals_state.dart';

class SavingsGoalsCubit extends Cubit<SavingsGoalsState> {
  SavingsGoalsCubit(this._getGoals, this._saveGoal, this._deleteGoal, this._clock, LedgerChanges changes)
    : super(const SavingsGoalsState()) {
    _subscription = changes.changes.listen((_) => load());
    load();
  }

  final GetGoalsUseCase _getGoals;
  final SaveGoalUseCase _saveGoal;
  final DeleteGoalUseCase _deleteGoal;
  final Clock _clock;
  late final StreamSubscription<void> _subscription;

  void load() => emit(state.copyWith(status: SavingsGoalsStatus.ready, goals: _getGoals(), today: _clock.today()));

  Future<void> save({
    Goal? existing,
    required String name,
    required double target,
    required double saved,
    required double monthly,
    required String fallbackName,
  }) => _saveGoal(
    existing: existing,
    name: name,
    target: target,
    saved: saved,
    monthly: monthly,
    fallbackName: fallbackName,
  );

  Future<void> delete(Goal goal) => _deleteGoal(goal.id);

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
