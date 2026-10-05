import 'package:equatable/equatable.dart';

class LabelEnvelope extends Equatable {
  const LabelEnvelope({required this.id, required this.name, required this.label, required this.amount});

  final String id;
  final String name;
  final String label;
  final double amount;

  LabelEnvelope copyWith({String? name, String? label, double? amount}) =>
      LabelEnvelope(id: id, name: name ?? this.name, label: label ?? this.label, amount: amount ?? this.amount);

  @override
  List<Object?> get props => [id, name, label, amount];
}
