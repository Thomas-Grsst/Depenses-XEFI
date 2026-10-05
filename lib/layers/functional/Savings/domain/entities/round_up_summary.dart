import 'package:equatable/equatable.dart';

class RoundUpSummary extends Equatable {
  const RoundUpSummary({required this.total, required this.thisMonth, required this.available, this.used = 0});

  final double total;
  final double thisMonth;
  final double available;
  final double used;

  @override
  List<Object?> get props => [total, thisMonth, available, used];
}
