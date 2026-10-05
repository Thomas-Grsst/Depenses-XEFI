import 'package:equatable/equatable.dart';

class AccountSummary extends Equatable {
  const AccountSummary({
    this.hasBalance = false,
    this.balance = 0,
    this.income = 0,
    this.payDay = 1,
    this.endOfMonth = 0,
    this.futureNoted = 0,
    this.nextPayday,
    this.payDatesLeftThisMonth = const [],
  });

  final bool hasBalance;
  final double balance;
  final double income;
  final int payDay;
  final double endOfMonth;
  final double futureNoted;
  final DateTime? nextPayday;
  final List<DateTime> payDatesLeftThisMonth;

  @override
  List<Object?> get props => [
    hasBalance,
    balance,
    income,
    payDay,
    endOfMonth,
    futureNoted,
    nextPayday,
    payDatesLeftThisMonth,
  ];
}
