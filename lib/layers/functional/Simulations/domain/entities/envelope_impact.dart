import 'package:equatable/equatable.dart';

class EnvelopeImpact extends Equatable {
  const EnvelopeImpact({
    required this.categoryName,
    required this.budget,
    required this.marginBefore,
    required this.marginAfter,
  });

  final String categoryName;
  final double budget;
  final double marginBefore;
  final double marginAfter;

  bool get isOverspentAfter => marginAfter < 0;

  bool get isWorse => isOverspentAfter || marginAfter < marginBefore;

  @override
  List<Object?> get props => [categoryName, budget, marginBefore, marginAfter];
}
