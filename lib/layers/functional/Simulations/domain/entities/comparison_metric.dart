import 'package:equatable/equatable.dart';

import 'comparison_metric_kind.dart';

class ComparisonMetric extends Equatable {
  const ComparisonMetric({required this.kind, required this.values, required this.highlights});

  final ComparisonMetricKind kind;
  final List<double?> values;
  final List<bool> highlights;

  @override
  List<Object?> get props => [kind, values, highlights];
}
