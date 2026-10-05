import 'dart:async';

import 'package:depenses/layers/functional/Categories/domain/use_cases/get_categories_use_case.dart';
import 'package:depenses/layers/technical/Storage/ledger_changes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/use_cases/compare_months_use_case.dart';
import '../../domain/use_cases/get_comparable_months_use_case.dart';
import 'compare_state.dart';

class CompareCubit extends Cubit<CompareState> {
  CompareCubit(this._compareMonths, this._getComparableMonths, this._getCategories, LedgerChanges changes)
    : super(const CompareState()) {
    _subscription = changes.changes.listen((_) => load());
    load();
  }

  final CompareMonthsUseCase _compareMonths;
  final GetComparableMonthsUseCase _getComparableMonths;
  final GetCategoriesUseCase _getCategories;
  late final StreamSubscription<void> _subscription;

  void load() => _compare(state.referenceMonth, state.isToDate);

  void selectReferenceMonth(DateTime month) => _compare(month, state.isToDate);

  void toggleToDate() => _compare(state.referenceMonth, !state.isToDate);

  void _compare(DateTime? referenceMonth, bool isToDate) {
    final comparison = _compareMonths(referenceMonth: referenceMonth, isToDate: isToDate);
    emit(
      state.copyWith(
        status: CompareStatus.ready,
        comparison: comparison,
        referenceMonth: comparison.referenceMonth,
        isToDate: isToDate,
        comparableMonths: _getComparableMonths(),
        categories: {for (final category in _getCategories()) category.key: category},
      ),
    );
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
