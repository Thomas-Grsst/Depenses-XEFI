import 'package:depenses/layers/functional/Account/domain/entities/account_summary.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/month_stats.dart';
import '../../domain/entities/recurrence_tally.dart';

enum ForecastStatus { loading, ready }

class ForecastState extends Equatable {
  const ForecastState({
    this.status = ForecastStatus.loading,
    this.stats,
    this.account = const AccountSummary(),
    this.remainingRecurrences = const [],
  });

  final ForecastStatus status;
  final MonthStats? stats;
  final AccountSummary account;
  final List<RecurrenceTally> remainingRecurrences;

  ForecastState copyWith({
    ForecastStatus? status,
    MonthStats? stats,
    AccountSummary? account,
    List<RecurrenceTally>? remainingRecurrences,
  }) => ForecastState(
    status: status ?? this.status,
    stats: stats ?? this.stats,
    account: account ?? this.account,
    remainingRecurrences: remainingRecurrences ?? this.remainingRecurrences,
  );

  @override
  List<Object?> get props => [status, stats, account, remainingRecurrences];
}
