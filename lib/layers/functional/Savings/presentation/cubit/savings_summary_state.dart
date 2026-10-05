import 'package:depenses/layers/functional/Expenses/domain/entities/expense.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/round_up_summary.dart';

enum SavingsSummaryStatus { loading, ready }

class SavingsSummaryState extends Equatable {
  const SavingsSummaryState({
    this.status = SavingsSummaryStatus.loading,
    this.isRoundUpEnabled = false,
    this.summary = const RoundUpSummary(total: 0, thisMonth: 0, available: 0),
    this.lastRounded,
    this.month,
  });

  final SavingsSummaryStatus status;
  final bool isRoundUpEnabled;
  final RoundUpSummary summary;
  final Expense? lastRounded;
  final DateTime? month;

  bool get isCardVisible => isRoundUpEnabled || summary.total > 0;

  SavingsSummaryState copyWith({
    SavingsSummaryStatus? status,
    bool? isRoundUpEnabled,
    RoundUpSummary? summary,
    Expense? Function()? lastRounded,
    DateTime? month,
  }) => SavingsSummaryState(
    status: status ?? this.status,
    isRoundUpEnabled: isRoundUpEnabled ?? this.isRoundUpEnabled,
    summary: summary ?? this.summary,
    lastRounded: lastRounded == null ? this.lastRounded : lastRounded(),
    month: month ?? this.month,
  );

  @override
  List<Object?> get props => [status, isRoundUpEnabled, summary, lastRounded, month];
}
