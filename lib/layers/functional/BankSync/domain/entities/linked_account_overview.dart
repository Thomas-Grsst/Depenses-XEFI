import 'package:equatable/equatable.dart';

import 'linked_bank_account.dart';

class LinkedAccountOverview extends Equatable {
  const LinkedAccountOverview({required this.account, required this.status});

  final LinkedBankAccount account;
  final LinkedAccountStatus status;

  bool get isExpired => status == LinkedAccountStatus.expired;

  @override
  List<Object?> get props => [account, status];
}
