import 'package:equatable/equatable.dart';

enum BankTransactionDirection { debit, credit }

class BankTransaction extends Equatable {
  const BankTransaction({
    required this.id,
    required this.date,
    required this.amount,
    required this.direction,
    required this.isPending,
    required this.rawLabel,
  });

  final String id;
  final DateTime date;
  final double amount;
  final BankTransactionDirection direction;
  final bool isPending;
  final String rawLabel;

  bool get isDebit => direction == BankTransactionDirection.debit;

  @override
  List<Object?> get props => [id, date, amount, direction, isPending, rawLabel];
}
