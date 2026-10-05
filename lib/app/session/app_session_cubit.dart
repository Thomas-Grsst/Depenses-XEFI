import 'dart:async';

import 'package:depenses/layers/functional/Profile/domain/use_cases/is_onboarded_use_case.dart';
import 'package:depenses/layers/functional/Recurrences/domain/use_cases/materialize_due_recurrences_use_case.dart';
import 'package:depenses/layers/technical/Storage/ledger_changes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_session_state.dart';

class AppSessionCubit extends Cubit<AppSessionState> {
  AppSessionCubit(this._isOnboarded, this._materializeDueRecurrences, LedgerChanges changes)
    : super(AppSessionState(isOnboarded: _isOnboarded())) {
    _subscription = changes.changes.listen((_) => _refresh());
    resume();
  }

  final IsOnboardedUseCase _isOnboarded;
  final MaterializeDueRecurrencesUseCase _materializeDueRecurrences;
  late final StreamSubscription<void> _subscription;

  Future<void> resume() => _materializeDueRecurrences();

  void completeOnboarding() => _refresh();

  void _refresh() => emit(AppSessionState(isOnboarded: _isOnboarded()));

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
