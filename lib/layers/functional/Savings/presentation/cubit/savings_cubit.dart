import 'dart:async';

import 'package:depenses/layers/functional/Categories/domain/use_cases/get_category_use_case.dart';
import 'package:depenses/layers/functional/Categories/domain/use_cases/look_up_merchant_use_case.dart';
import 'package:depenses/layers/functional/Expenses/domain/use_cases/get_round_up_enabled_use_case.dart';
import 'package:depenses/layers/functional/Expenses/domain/use_cases/set_round_up_enabled_use_case.dart';
import 'package:depenses/layers/technical/Calendar/clock.dart';
import 'package:depenses/layers/technical/Storage/ledger_changes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/goal.dart';
import '../../domain/use_cases/get_goals_use_case.dart';
import '../../domain/use_cases/get_round_up_summary_use_case.dart';
import '../../domain/use_cases/get_rounded_expenses_use_case.dart';
import '../../domain/use_cases/move_round_up_to_goal_use_case.dart';
import 'savings_state.dart';

const _recentRoundedShown = 8;

class SavingsCubit extends Cubit<SavingsState> {
  SavingsCubit(
    this._isRoundUpEnabled,
    this._setRoundUpEnabled,
    this._getSummary,
    this._getRounded,
    this._getGoals,
    this._moveRoundUp,
    this._lookUpMerchant,
    this._getCategory,
    this._clock,
    LedgerChanges changes,
  ) : super(const SavingsState()) {
    _subscription = changes.changes.listen((_) => load());
    load();
  }

  final GetRoundUpEnabledUseCase _isRoundUpEnabled;
  final SetRoundUpEnabledUseCase _setRoundUpEnabled;
  final GetRoundUpSummaryUseCase _getSummary;
  final GetRoundedExpensesUseCase _getRounded;
  final GetGoalsUseCase _getGoals;
  final MoveRoundUpToGoalUseCase _moveRoundUp;
  final LookUpMerchantUseCase _lookUpMerchant;
  final GetCategoryUseCase _getCategory;
  final Clock _clock;
  late final StreamSubscription<void> _subscription;

  void load() {
    final recent = _getRounded().take(_recentRoundedShown).toList();
    emit(
      state.copyWith(
        status: SavingsStatus.ready,
        isRoundUpEnabled: _isRoundUpEnabled(),
        summary: _getSummary(_clock.today()),
        goals: _getGoals(),
        recentRounded: recent,
        looks: {for (final e in recent) e.id: _lookUpMerchant(e.name, e.categoryKey)},
        categories: {for (final e in recent) e.categoryKey: _getCategory(e.categoryKey)},
      ),
    );
  }

  Future<void> setRoundUpEnabled(bool isEnabled) => _setRoundUpEnabled(isEnabled);

  Future<void> moveToGoal(Goal goal) async {
    await _moveRoundUp(goal);
    final funded = _getGoals().where((g) => g.id == goal.id).firstOrNull;
    if (funded != null) emit(state.copyWith(fundedGoal: funded));
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
