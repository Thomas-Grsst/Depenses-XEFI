import 'dart:async';

import 'package:depenses/layers/technical/Storage/ledger_changes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/use_cases/get_categories_use_case.dart';
import 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit(this._getCategories, LedgerChanges changes) : super(const CategoriesState()) {
    _subscription = changes.changes.listen((_) => load());
    load();
  }

  final GetCategoriesUseCase _getCategories;
  late final StreamSubscription<void> _subscription;

  void load() => emit(state.copyWith(categories: _getCategories()));

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
