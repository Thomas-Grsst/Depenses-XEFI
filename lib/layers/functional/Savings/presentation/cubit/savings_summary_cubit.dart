import 'dart:async';

import 'package:depenses/layers/functional/Expenses/domain/use_cases/get_round_up_enabled_use_case.dart';
import 'package:depenses/layers/technical/Calendar/calendar_day.dart';
import 'package:depenses/layers/technical/Calendar/clock.dart';
import 'package:depenses/layers/technical/Storage/ledger_changes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/use_cases/get_round_up_summary_use_case.dart';
import '../../domain/use_cases/get_rounded_expenses_use_case.dart';
import 'savings_summary_state.dart';

class SavingsSummaryCubit extends Cubit<SavingsSummaryState> {
  SavingsSummaryCubit(this._isRoundUpEnabled, this._getSummary, this._getRounded, this._clock, LedgerChanges changes)
    : super(const SavingsSummaryState()) {
    _subscription = changes.changes.listen((_) => load());
    load();
  }

  final GetRoundUpEnabledUseCase _isRoundUpEnabled;
  final GetRoundUpSummaryUseCase _getSummary;
  final GetRoundedExpensesUseCase _getRounded;
  final Clock _clock;
  late final StreamSubscription<void> _subscription;

  void load() {
    final month = _clock.today().firstOfMonth;
    emit(
      state.copyWith(
        status: SavingsSummaryStatus.ready,
        isRoundUpEnabled: _isRoundUpEnabled(),
        summary: _getSummary(month),
        lastRounded: () => _getRounded().firstOrNull,
        month: month,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
