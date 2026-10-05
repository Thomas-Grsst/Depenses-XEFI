import 'package:equatable/equatable.dart';

import '../../domain/entities/bank.dart';
import 'bank_sync_failure.dart';

enum BankPickerStatus { loading, ready, failed, authorizing, awaitingCallback }

class BankPickerState extends Equatable {
  const BankPickerState({
    this.status = BankPickerStatus.loading,
    this.banks = const [],
    this.visibleBanks = const [],
    this.query = '',
    this.selectedBank,
    this.callback,
    this.isPasteInvalid = false,
    this.failure = BankSyncFailure.none,
  });

  final BankPickerStatus status;
  final List<Bank> banks;
  final List<Bank> visibleBanks;
  final String query;
  final Bank? selectedBank;
  final Uri? callback;
  final bool isPasteInvalid;
  final BankSyncFailure failure;

  bool get isAwaitingCallback => status == BankPickerStatus.awaitingCallback;

  bool get isAuthorizing => status == BankPickerStatus.authorizing;

  BankPickerState copyWith({
    BankPickerStatus? status,
    List<Bank>? banks,
    List<Bank>? visibleBanks,
    String? query,
    Bank? selectedBank,
    Uri? callback,
    bool? isPasteInvalid,
    BankSyncFailure? failure,
  }) => BankPickerState(
    status: status ?? this.status,
    banks: banks ?? this.banks,
    visibleBanks: visibleBanks ?? this.visibleBanks,
    query: query ?? this.query,
    selectedBank: selectedBank ?? this.selectedBank,
    callback: callback ?? this.callback,
    isPasteInvalid: isPasteInvalid ?? this.isPasteInvalid,
    failure: failure ?? this.failure,
  );

  @override
  List<Object?> get props => [status, banks, visibleBanks, query, selectedBank, callback, isPasteInvalid, failure];
}
