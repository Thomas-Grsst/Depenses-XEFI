import 'package:equatable/equatable.dart';

import 'hypothesis.dart';

class Scenario extends Equatable {
  const Scenario({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.hypotheses,
  });

  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final List<Hypothesis> hypotheses;

  double get monthlyDelta => hypotheses.fold(0.0, (total, h) => total + h.monthlyDelta);

  Scenario copyWith({String? title, String? description, List<Hypothesis>? hypotheses}) => Scenario(
    id: id,
    title: title ?? this.title,
    description: description ?? this.description,
    createdAt: createdAt,
    hypotheses: hypotheses ?? this.hypotheses,
  );

  @override
  List<Object?> get props => [id, title, description, createdAt, hypotheses];
}
