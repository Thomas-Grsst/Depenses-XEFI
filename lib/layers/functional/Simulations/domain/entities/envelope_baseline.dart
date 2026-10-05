import 'package:equatable/equatable.dart';

class EnvelopeBaseline extends Equatable {
  const EnvelopeBaseline({
    required this.categoryKey,
    required this.categoryName,
    required this.budget,
    required this.projected,
  });

  final String categoryKey;
  final String categoryName;
  final double budget;
  final double projected;

  double get margin => budget - projected;

  @override
  List<Object?> get props => [categoryKey, categoryName, budget, projected];
}
