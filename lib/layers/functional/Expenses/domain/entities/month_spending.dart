import 'package:equatable/equatable.dart';

class MonthSpending extends Equatable {
  const MonthSpending({required this.month, required this.total});

  final DateTime month;
  final double total;

  @override
  List<Object?> get props => [month, total];
}
