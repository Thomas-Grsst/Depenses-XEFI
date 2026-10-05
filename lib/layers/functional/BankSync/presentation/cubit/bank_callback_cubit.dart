import 'package:depenses/layers/technical/OpenBanking/callback/authorization_callback.dart';
import 'package:depenses/layers/technical/OpenBanking/enable_banking_errors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/bank_authorization_cancelled_exception.dart';
import '../../domain/entities/bank_authorization_rejected_exception.dart';
import '../../domain/use_cases/complete_bank_authorization_use_case.dart';
import 'bank_callback_state.dart';
import 'bank_sync_failure.dart';

class BankCallbackCubit extends Cubit<BankCallbackState> {
  BankCallbackCubit(this._completeAuthorization) : super(const BankCallbackState());

  final CompleteBankAuthorizationUseCase _completeAuthorization;
  bool _hasStarted = false;

  Future<void> complete(Uri uri) async {
    if (_hasStarted) return;
    _hasStarted = true;
    final callback = AuthorizationCallback.fromUri(uri);
    try {
      final accounts = await _completeAuthorization(code: callback.code, state: callback.state, error: callback.error);
      _emit(BankCallbackState(status: BankCallbackStatus.linked, accounts: accounts));
    } on BankAuthorizationCancelledException {
      _emit(const BankCallbackState(status: BankCallbackStatus.cancelled));
    } on BankAuthorizationRejectedException {
      _emit(const BankCallbackState(status: BankCallbackStatus.rejected));
    } on BankApiException catch (error) {
      _emit(BankCallbackState(status: BankCallbackStatus.failed, failure: BankSyncFailure.of(error)));
    }
  }

  void _emit(BankCallbackState next) {
    if (!isClosed) emit(next);
  }
}
