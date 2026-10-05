import 'package:depenses/layers/functional/Forecast/domain/entities/month_stats.dart';
import 'package:depenses/layers/functional/Forecast/domain/entities/recurrence_tally.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/account_summary.dart';

enum AccountStatus { loading, ready, saving, saved }

class AccountState extends Equatable {
  const AccountState({
    this.status = AccountStatus.loading,
    this.stats,
    this.summary = const AccountSummary(),
    this.remainingRecurrences = const [],
    this.payDay = 1,
  });

  final AccountStatus status;
  final MonthStats? stats;
  final AccountSummary summary;
  final List<RecurrenceTally> remainingRecurrences;
  final int payDay;

  bool get isLoaded => status != AccountStatus.loading;

  AccountState copyWith({
    AccountStatus? status,
    MonthStats? stats,
    AccountSummary? summary,
    List<RecurrenceTally>? remainingRecurrences,
    int? payDay,
  }) => AccountState(
    status: status ?? this.status,
    stats: stats ?? this.stats,
    summary: summary ?? this.summary,
    remainingRecurrences: remainingRecurrences ?? this.remainingRecurrences,
    payDay: payDay ?? this.payDay,
  );

  @override
  List<Object?> get props => [status, stats, summary, remainingRecurrences, payDay];
}
