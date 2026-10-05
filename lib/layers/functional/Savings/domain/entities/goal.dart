import 'dart:math';

import 'package:equatable/equatable.dart';

const _negligibleMonthlySaving = 0.004;

class Goal extends Equatable {
  const Goal({required this.id, required this.name, required this.target, required this.saved, required this.monthly});

  final String id;
  final String name;
  final double target;
  final double saved;
  final double monthly;

  double get remaining => max(0, target - saved);

  int? monthsWith(double perMonth) {
    if (remaining <= 0) return 0;
    if (perMonth <= _negligibleMonthlySaving) return null;
    return (remaining / perMonth).ceil();
  }

  Goal copyWith({String? name, double? target, double? saved, double? monthly}) => Goal(
    id: id,
    name: name ?? this.name,
    target: target ?? this.target,
    saved: saved ?? this.saved,
    monthly: monthly ?? this.monthly,
  );

  @override
  List<Object?> get props => [id, name, target, saved, monthly];
}
