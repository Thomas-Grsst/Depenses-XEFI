import 'package:equatable/equatable.dart';

class AccountSettings extends Equatable {
  const AccountSettings({
    this.income = 0,
    this.payDay = 1,
    this.balance,
    this.balanceDate,
    this.balanceSkip = const [],
  });

  final double income;
  final int payDay;
  final double? balance;
  final DateTime? balanceDate;
  final List<String> balanceSkip;

  bool get hasBalance => balance != null && balanceDate != null;

  AccountSettings copyWith({double? income, int? payDay}) => AccountSettings(
    income: income ?? this.income,
    payDay: payDay ?? this.payDay,
    balance: balance,
    balanceDate: balanceDate,
    balanceSkip: balanceSkip,
  );

  AccountSettings withBalance(double? balance, DateTime? balanceDate, List<String> balanceSkip) => AccountSettings(
    income: income,
    payDay: payDay,
    balance: balance,
    balanceDate: balanceDate,
    balanceSkip: balanceSkip,
  );

  @override
  List<Object?> get props => [income, payDay, balance, balanceDate, balanceSkip];
}
