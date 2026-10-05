import 'package:equatable/equatable.dart';

import '../../domain/entities/linked_bank_account.dart';
import 'bank_sync_failure.dart';

enum BankCallbackStatus { completing, linked, cancelled, rejected, failed }

class BankCallbackState extends Equatable {
  const BankCallbackState({
    this.status = BankCallbackStatus.completing,
    this.accounts = const [],
    this.failure = BankSyncFailure.none,
  });

  final BankCallbackStatus status;
  final List<LinkedBankAccount> accounts;
  final BankSyncFailure failure;

  bool get isCompleting => status == BankCallbackStatus.completing;

  @override
  List<Object?> get props => [status, accounts, failure];
}
