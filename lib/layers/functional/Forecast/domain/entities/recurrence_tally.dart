import 'package:equatable/equatable.dart';

class RecurrenceTally extends Equatable {
  const RecurrenceTally({required this.name, required this.count});

  final String name;
  final int count;

  bool get isRepeated => count > 1;

  @override
  List<Object?> get props => [name, count];
}
