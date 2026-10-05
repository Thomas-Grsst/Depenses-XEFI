import 'package:equatable/equatable.dart';

const _alignmentThresholdInCents = 100;

class BalanceGap extends Equatable {
  const BalanceGap({required this.bankBalance, this.appBalance});

  final double bankBalance;
  final double? appBalance;

  bool get hasAppBalance => appBalance != null;

  double get difference => _toEuros(_cents(bankBalance) - _cents(appBalance ?? 0));

  bool get isWorthAligning => !hasAppBalance || _cents(difference).abs() > _alignmentThresholdInCents;

  static int _cents(double amount) => (amount * 100).round();

  static double _toEuros(int cents) => cents / 100;

  @override
  List<Object?> get props => [bankBalance, appBalance];
}
