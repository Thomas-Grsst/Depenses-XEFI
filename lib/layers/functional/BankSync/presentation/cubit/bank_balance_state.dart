import 'package:equatable/equatable.dart';

import '../../domain/entities/balance_gap.dart';

class BankBalanceState extends Equatable {
  const BankBalanceState({this.gap, this.isAligning = false});

  final BalanceGap? gap;
  final bool isAligning;

  bool get isWorthAligning => gap?.isWorthAligning ?? false;

  BankBalanceState copyWith({BalanceGap? gap, bool clearsGap = false, bool? isAligning}) =>
      BankBalanceState(gap: clearsGap ? null : gap ?? this.gap, isAligning: isAligning ?? this.isAligning);

  @override
  List<Object?> get props => [gap, isAligning];
}
