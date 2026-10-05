import 'dart:async';

import 'package:depenses/layers/technical/OpenBanking/authorization_callback_listener.dart';
import 'package:depenses/layers/technical/OpenBanking/callback/authorization_browser.dart';
import 'package:depenses/layers/technical/OpenBanking/callback/authorization_callback.dart';
import 'package:depenses/layers/technical/OpenBanking/enable_banking_errors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/bank.dart';
import '../../domain/use_cases/get_banks_use_case.dart';
import '../../domain/use_cases/search_banks_use_case.dart';
import '../../domain/use_cases/start_bank_authorization_use_case.dart';
import 'bank_picker_state.dart';
import 'bank_sync_failure.dart';

class BankPickerCubit extends Cubit<BankPickerState> {
  BankPickerCubit(this._getBanks, this._searchBanks, this._startAuthorization, this._listener)
    : super(const BankPickerState()) {
    _subscription = _listener.callbacks.listen(_receive);
  }

  final GetBanksUseCase _getBanks;
  final SearchBanksUseCase _searchBanks;
  final StartBankAuthorizationUseCase _startAuthorization;
  final AuthorizationCallbackListener _listener;
  late final StreamSubscription<Uri> _subscription;

  Future<void> load({String query = ''}) async {
    emit(state.copyWith(status: BankPickerStatus.loading, query: query, failure: BankSyncFailure.none));
    try {
      final banks = await _getBanks();
      if (isClosed) return;
      emit(
        state.copyWith(status: BankPickerStatus.ready, banks: banks, visibleBanks: _searchBanks(banks, state.query)),
      );
    } on BankApiException catch (error) {
      if (isClosed) return;
      emit(state.copyWith(status: BankPickerStatus.failed, failure: BankSyncFailure.of(error)));
    }
  }

  void search(String query) => emit(state.copyWith(query: query, visibleBanks: _searchBanks(state.banks, query)));

  Future<void> authorize(Bank bank, {required String returnMessage}) async {
    if (state.isAuthorizing) return;
    emit(state.copyWith(status: BankPickerStatus.authorizing, selectedBank: bank, failure: BankSyncFailure.none));
    try {
      final url = await _startAuthorization(bank, redirectUrl: _listener.redirectUrl);
      await _listener.open(url, returnMessage: returnMessage);
      _settle(BankPickerStatus.awaitingCallback);
    } on BankApiException catch (error) {
      _settle(BankPickerStatus.ready, BankSyncFailure.of(error));
    } on AuthorizationBrowserException {
      _settle(BankPickerStatus.ready, BankSyncFailure.browserUnavailable);
    }
  }

  void paste(String text) {
    final callback = AuthorizationCallback.uriFromText(text);
    if (callback == null) {
      emit(state.copyWith(isPasteInvalid: true));
      return;
    }
    _receive(callback);
  }

  void _receive(Uri callback) {
    if (isClosed) return;
    emit(state.copyWith(callback: callback, isPasteInvalid: false));
  }

  void _settle(BankPickerStatus status, [BankSyncFailure failure = BankSyncFailure.none]) {
    if (isClosed) return;
    emit(state.copyWith(status: status, failure: failure));
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    await _listener.close();
    return super.close();
  }
}
