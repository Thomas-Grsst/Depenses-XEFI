import 'dart:async';

import 'package:depenses/layers/functional/Categories/domain/use_cases/get_categories_use_case.dart';
import 'package:depenses/layers/technical/Storage/ledger_changes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/use_cases/get_forecast_summary_use_case.dart';
import 'forecast_summary_state.dart';

class ForecastSummaryCubit extends Cubit<ForecastSummaryState> {
  ForecastSummaryCubit(this._getSummary, this._getCategories, LedgerChanges changes)
    : super(const ForecastSummaryState()) {
    _subscription = changes.changes.listen((_) => load());
    load();
  }

  final GetForecastSummaryUseCase _getSummary;
  final GetCategoriesUseCase _getCategories;
  late final StreamSubscription<void> _subscription;

  void load() => emit(
    state.copyWith(
      status: ForecastSummaryStatus.ready,
      summary: _getSummary(),
      categories: {for (final category in _getCategories()) category.key: category},
    ),
  );

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
