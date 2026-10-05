import 'dart:async';

import 'package:depenses/layers/technical/Storage/ledger_changes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/use_cases/align_balance_on_bank_use_case.dart';
import '../../domain/use_cases/get_balance_gap_use_case.dart';
import 'bank_balance_state.dart';

class BankBalanceCubit extends Cubit<BankBalanceState> {
  BankBalanceCubit(this._getGap, this._align, LedgerChanges changes) : super(const BankBalanceState()) {
    _subscription = changes.changes.listen((_) => load());
    load();
  }

  final GetBalanceGapUseCase _getGap;
  final AlignBalanceOnBankUseCase _align;
  late final StreamSubscription<void> _subscription;

  void load() {
    if (isClosed) return;
    final gap = _getGap();
    emit(state.copyWith(gap: gap, clearsGap: gap == null));
  }

  Future<void> align() async {
    if (state.isAligning || !state.isWorthAligning) return;
    emit(state.copyWith(isAligning: true));
    await _align();
    if (isClosed) return;
    final gap = _getGap();
    emit(state.copyWith(gap: gap, clearsGap: gap == null, isAligning: false));
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
