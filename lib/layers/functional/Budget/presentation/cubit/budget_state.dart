import 'package:depenses/layers/functional/Budget/domain/entities/category_envelope.dart';
import 'package:depenses/layers/functional/Budget/domain/entities/label_envelope_progress.dart';
import 'package:depenses/layers/functional/Forecast/domain/entities/month_stats.dart';
import 'package:equatable/equatable.dart';

class BudgetState extends Equatable {
  const BudgetState({
    this.stats,
    this.categoryEnvelopes = const [],
    this.labelEnvelopes = const [],
    this.labels = const [],
  });

  final MonthStats? stats;
  final List<CategoryEnvelope> categoryEnvelopes;
  final List<LabelEnvelopeProgress> labelEnvelopes;
  final List<String> labels;

  bool get hasBudget => (stats?.budget ?? 0) > 0;

  double get margin {
    final current = stats;
    return current == null ? 0 : current.budget - current.forecast;
  }

  BudgetState copyWith({
    MonthStats? stats,
    List<CategoryEnvelope>? categoryEnvelopes,
    List<LabelEnvelopeProgress>? labelEnvelopes,
    List<String>? labels,
  }) => BudgetState(
    stats: stats ?? this.stats,
    categoryEnvelopes: categoryEnvelopes ?? this.categoryEnvelopes,
    labelEnvelopes: labelEnvelopes ?? this.labelEnvelopes,
    labels: labels ?? this.labels,
  );

  @override
  List<Object?> get props => [stats, categoryEnvelopes, labelEnvelopes, labels];
}
