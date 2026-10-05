import 'dart:async';

import 'package:depenses/layers/functional/Categories/domain/use_cases/get_category_use_case.dart';
import 'package:depenses/layers/functional/Categories/domain/use_cases/look_up_merchant_use_case.dart';
import 'package:depenses/layers/functional/Expenses/domain/use_cases/describe_expenses_use_case.dart';
import 'package:depenses/layers/functional/Expenses/domain/use_cases/get_recent_expenses_use_case.dart';
import 'package:depenses/layers/functional/Profile/domain/use_cases/get_profile_name_use_case.dart';
import 'package:depenses/layers/functional/Recurrences/domain/use_cases/get_next_occurrences_use_case.dart';
import 'package:depenses/layers/technical/Calendar/clock.dart';
import 'package:depenses/layers/technical/Storage/ledger_changes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_lists_state.dart';
import 'home_occurrence.dart';

const _listLength = 3;

class HomeListsCubit extends Cubit<HomeListsState> {
  HomeListsCubit(
    this._nextOccurrences,
    this._recentExpenses,
    this._describeExpenses,
    this._lookUpMerchant,
    this._getCategory,
    this._profileName,
    this._clock,
    LedgerChanges changes,
  ) : super(HomeListsState(name: '', today: _clock.today())) {
    _subscription = changes.changes.listen((_) => load());
    load();
  }

  final GetNextOccurrencesUseCase _nextOccurrences;
  final GetRecentExpensesUseCase _recentExpenses;
  final DescribeExpensesUseCase _describeExpenses;
  final LookUpMerchantUseCase _lookUpMerchant;
  final GetCategoryUseCase _getCategory;
  final GetProfileNameUseCase _profileName;
  final Clock _clock;
  late final StreamSubscription<void> _subscription;

  void load() => emit(
    HomeListsState(
      name: _profileName(),
      today: _clock.today(),
      upcoming: [
        for (final occurrence in _nextOccurrences(_listLength))
          HomeOccurrence(
            occurrence: occurrence,
            look: _lookUpMerchant(occurrence.recurrence.name, occurrence.recurrence.categoryKey),
            category: _getCategory(occurrence.recurrence.categoryKey),
          ),
      ],
      recent: _describeExpenses(_recentExpenses(_listLength)),
    ),
  );

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
