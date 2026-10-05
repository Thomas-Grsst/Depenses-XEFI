import 'package:equatable/equatable.dart';

import '../../domain/entities/account_summary.dart';

enum AccountSummaryStatus { loading, ready }

class AccountSummaryState extends Equatable {
  const AccountSummaryState({
    this.status = AccountSummaryStatus.loading,
    this.summary = const AccountSummary(),
    this.today,
  });

  final AccountSummaryStatus status;
  final AccountSummary summary;
  final DateTime? today;

  AccountSummaryState copyWith({AccountSummaryStatus? status, AccountSummary? summary, DateTime? today}) =>
      AccountSummaryState(status: status ?? this.status, summary: summary ?? this.summary, today: today ?? this.today);

  @override
  List<Object?> get props => [status, summary, today];
}
