import 'package:equatable/equatable.dart';

import 'recurrence.dart';

class Occurrence extends Equatable {
  const Occurrence(this.date, this.recurrence);

  final DateTime date;
  final Recurrence recurrence;

  @override
  List<Object?> get props => [date, recurrence];
}
