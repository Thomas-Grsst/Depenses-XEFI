import 'package:equatable/equatable.dart';

class ScheduleEntry extends Equatable {
  const ScheduleEntry({required this.name, required this.categoryKey, required this.amount, required this.isPlanned});

  final String name;
  final String categoryKey;
  final double amount;
  final bool isPlanned;

  @override
  List<Object?> get props => [name, categoryKey, amount, isPlanned];
}
