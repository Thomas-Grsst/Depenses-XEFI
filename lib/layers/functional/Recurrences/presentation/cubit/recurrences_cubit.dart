import 'dart:async';

import 'package:depenses/layers/functional/Categories/domain/use_cases/get_categories_use_case.dart';
import 'package:depenses/layers/functional/Categories/domain/use_cases/look_up_merchant_use_case.dart';
import 'package:depenses/layers/functional/Recurrences/domain/entities/recurring_suggestion.dart';
import 'package:depenses/layers/functional/Recurrences/domain/entities/schedule_entry.dart';
import 'package:depenses/layers/functional/Recurrences/domain/use_cases/accept_suggestion_use_case.dart';
import 'package:depenses/layers/functional/Recurrences/domain/use_cases/detect_recurring_expenses_use_case.dart';
import 'package:depenses/layers/functional/Recurrences/domain/use_cases/get_fixed_monthly_total_use_case.dart';
import 'package:depenses/layers/functional/Recurrences/domain/use_cases/get_month_schedule_use_case.dart';
import 'package:depenses/layers/functional/Recurrences/domain/use_cases/get_next_occurrences_use_case.dart';
import 'package:depenses/layers/functional/Recurrences/domain/use_cases/get_recurrences_by_monthly_amount_use_case.dart';
import 'package:depenses/layers/functional/Recurrences/domain/use_cases/ignore_suggestion_use_case.dart';
import 'package:depenses/layers/technical/Storage/ledger_changes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'merchant_badges.dart';
import 'recurrences_mode.dart';
import 'recurrences_state.dart';

const _nextOccurrencesCount = 5;

class RecurrencesCubit extends Cubit<RecurrencesState> {
  RecurrencesCubit(
    this._getRecurrences,
    this._getNextOccurrences,
    this._getFixedMonthlyTotal,
    this._detectSuggestions,
    this._acceptSuggestion,
    this._ignoreSuggestion,
    this._getMonthSchedule,
    this._getCategories,
    this._lookUpMerchant,
    LedgerChanges changes,
  ) : super(const RecurrencesState()) {
    _subscription = changes.changes.listen((_) => load());
    load();
  }

  final GetRecurrencesByMonthlyAmountUseCase _getRecurrences;
  final GetNextOccurrencesUseCase _getNextOccurrences;
  final GetFixedMonthlyTotalUseCase _getFixedMonthlyTotal;
  final DetectRecurringExpensesUseCase _detectSuggestions;
  final AcceptSuggestionUseCase _acceptSuggestion;
  final IgnoreSuggestionUseCase _ignoreSuggestion;
  final GetMonthScheduleUseCase _getMonthSchedule;
  final GetCategoriesUseCase _getCategories;
  final LookUpMerchantUseCase _lookUpMerchant;
  late final StreamSubscription<void> _subscription;

  void load() {
    final current = _getMonthSchedule();
    final visibleMonth = state.visibleSchedule?.month;
    final loaded = state.copyWith(
      recurrences: _getRecurrences(),
      nextOccurrences: _getNextOccurrences(_nextOccurrencesCount),
      suggestions: _detectSuggestions(),
      fixedMonthly: _getFixedMonthlyTotal(),
      currentSchedule: current,
      visibleSchedule: visibleMonth == null ? current : _getMonthSchedule(visibleMonth),
      selectedDay: state.selectedDay ?? current.today,
    );
    emit(loaded.copyWith(badges: _badgesFor(loaded)));
  }

  void showMode(RecurrencesMode mode) => emit(state.copyWith(mode: mode));

  void selectDay(DateTime day) => emit(state.copyWith(selectedDay: day));

  void shiftMonth(int delta) {
    final month = state.visibleSchedule?.month;
    if (month == null) return;
    final shifted = state.copyWith(visibleSchedule: _getMonthSchedule(DateTime(month.year, month.month + delta)));
    emit(shifted.copyWith(badges: _badgesFor(shifted)));
  }

  Future<void> acceptSuggestion(RecurringSuggestion suggestion) => _acceptSuggestion(suggestion);

  Future<void> ignoreSuggestion(RecurringSuggestion suggestion) => _ignoreSuggestion(suggestion);

  MerchantBadges _badgesFor(RecurrencesState source) {
    final merchants = <(String, String)>{
      for (final r in source.recurrences) (r.name, r.categoryKey),
      for (final o in source.nextOccurrences) (o.recurrence.name, o.recurrence.categoryKey),
      for (final s in source.suggestions) (s.name, s.categoryKey),
      for (final entries in source.visibleSchedule?.entriesByDay.values ?? const <List<ScheduleEntry>>[])
        for (final e in entries) (e.name, e.categoryKey),
    };
    return MerchantBadges(
      categories: {for (final c in _getCategories()) c.key: c},
      looks: {for (final m in merchants) m: _lookUpMerchant(m.$1, m.$2)},
    );
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
