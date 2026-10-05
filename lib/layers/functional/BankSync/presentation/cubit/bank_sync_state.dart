import 'package:equatable/equatable.dart';

import '../../domain/entities/linked_account_overview.dart';
import '../../domain/entities/sync_report.dart';
import 'bank_sync_failure.dart';

enum BankSyncStatus { ready, synchronizing, unlinking }

class BankSyncState extends Equatable {
  const BankSyncState({
    this.status = BankSyncStatus.ready,
    this.isAvailable = false,
    this.accounts = const [],
    this.report,
    this.failure = BankSyncFailure.none,
  });

  final BankSyncStatus status;
  final bool isAvailable;
  final List<LinkedAccountOverview> accounts;
  final SyncReport? report;
  final BankSyncFailure failure;

  bool get hasAccounts => accounts.isNotEmpty;

  bool get isBusy => status != BankSyncStatus.ready;

  bool get isSynchronizing => status == BankSyncStatus.synchronizing;

  BankSyncState copyWith({
    BankSyncStatus? status,
    bool? isAvailable,
    List<LinkedAccountOverview>? accounts,
    SyncReport? report,
    bool clearsReport = false,
    BankSyncFailure? failure,
  }) => BankSyncState(
    status: status ?? this.status,
    isAvailable: isAvailable ?? this.isAvailable,
    accounts: accounts ?? this.accounts,
    report: clearsReport ? null : report ?? this.report,
    failure: failure ?? this.failure,
  );

  @override
  List<Object?> get props => [status, isAvailable, accounts, report, failure];
}
