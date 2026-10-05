import 'package:depenses/layers/functional/Categories/domain/entities/category.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/forecast_summary.dart';

enum ForecastSummaryStatus { loading, ready }

class ForecastSummaryState extends Equatable {
  const ForecastSummaryState({this.status = ForecastSummaryStatus.loading, this.summary, this.categories = const {}});

  final ForecastSummaryStatus status;
  final ForecastSummary? summary;
  final Map<String, Category> categories;

  bool get hasAlerts => summary?.alerts.isNotEmpty ?? false;

  ForecastSummaryState copyWith({
    ForecastSummaryStatus? status,
    ForecastSummary? summary,
    Map<String, Category>? categories,
  }) => ForecastSummaryState(
    status: status ?? this.status,
    summary: summary ?? this.summary,
    categories: categories ?? this.categories,
  );

  @override
  List<Object?> get props => [status, summary, categories];
}
