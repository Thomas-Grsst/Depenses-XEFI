import 'dart:math';

import 'package:equatable/equatable.dart';

import 'category_move.dart';

class MonthComparison extends Equatable {
  const MonthComparison({
    required this.today,
    required this.referenceMonth,
    required this.isToDate,
    required this.currentTotal,
    required this.referenceTotal,
    required this.moves,
    required this.hasReferenceData,
  });

  final DateTime today;
  final DateTime referenceMonth;
  final bool isToDate;
  final double currentTotal;
  final double referenceTotal;
  final List<CategoryMove> moves;
  final bool hasReferenceData;

  double get difference => currentTotal - referenceTotal;

  double? get ratio => referenceTotal > 0 ? currentTotal / referenceTotal - 1 : null;

  double get largestDelta => moves.fold(1.0, (largest, move) => max(largest, move.delta.abs()));

  CategoryMove? get biggestDrop {
    if (moves.isEmpty) return null;
    final lowest = moves.reduce((a, b) => b.delta < a.delta ? b : a);
    return lowest.delta < 0 ? lowest : null;
  }

  CategoryMove? get biggestRise {
    if (moves.isEmpty) return null;
    final highest = moves.reduce((a, b) => b.delta > a.delta ? b : a);
    return highest.delta > 0 ? highest : null;
  }

  @override
  List<Object?> get props => [today, referenceMonth, isToDate, currentTotal, referenceTotal, moves, hasReferenceData];
}
