import 'dart:async';

import 'package:depenses/layers/functional/Categories/domain/use_cases/get_categories_use_case.dart';
import 'package:depenses/layers/functional/Categories/domain/use_cases/guess_category_use_case.dart';
import 'package:depenses/layers/functional/Categories/domain/use_cases/look_up_merchant_use_case.dart';
import 'package:depenses/layers/functional/Forecast/domain/use_cases/compute_month_stats_use_case.dart';
import 'package:depenses/layers/functional/Recurrences/domain/entities/frequency.dart';
import 'package:depenses/layers/technical/Calendar/calendar_day.dart';
import 'package:depenses/layers/technical/Calendar/clock.dart';
import 'package:depenses/layers/technical/Storage/ledger_changes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/expense_entry.dart';
import '../../domain/use_cases/add_label_use_case.dart';
import '../../domain/use_cases/delete_expense_entry_use_case.dart';
import '../../domain/use_cases/get_labels_use_case.dart';
import '../../domain/use_cases/preview_next_occurrence_use_case.dart';
import '../../domain/use_cases/preview_round_up_use_case.dart';
import '../../domain/use_cases/save_expense_entry_use_case.dart';
import 'expense_editor_initial_state.dart';
import 'expense_editor_state.dart';
import 'expense_editor_status.dart';
import 'expense_editor_target.dart';

class ExpenseEditorCubit extends Cubit<ExpenseEditorState> {
  ExpenseEditorCubit(
    this._saveEntry,
    this._deleteEntry,
    this._getLabels,
    this._addLabel,
    this._getCategories,
    this._guessCategory,
    this._lookUpMerchant,
    this._previewRoundUp,
    this._previewNextOccurrence,
    this._computeStats,
    this._clock,
    LedgerChanges changes,
    ExpenseEditorTarget target,
  ) : super(initialExpenseEditorState(target, _clock.today())) {
    _subscription = changes.changes.listen((_) => _reload());
    _reload();
    _refreshPreviews();
  }

  final SaveExpenseEntryUseCase _saveEntry;
  final DeleteExpenseEntryUseCase _deleteEntry;
  final GetLabelsUseCase _getLabels;
  final AddLabelUseCase _addLabel;
  final GetCategoriesUseCase _getCategories;
  final GuessCategoryUseCase _guessCategory;
  final LookUpMerchantUseCase _lookUpMerchant;
  final PreviewRoundUpUseCase _previewRoundUp;
  final PreviewNextOccurrenceUseCase _previewNextOccurrence;
  final ComputeMonthStatsUseCase _computeStats;
  final Clock _clock;
  late final StreamSubscription<void> _subscription;

  void changeAmount(double? amount) {
    emit(state.copyWith(amount: () => amount == null || amount <= 0 ? null : amount));
    _refreshPreviews();
  }

  void changeName(String name) {
    final guessed = state.isCategoryTouched ? null : _guessCategory(name);
    emit(state.copyWith(name: name, categoryKey: guessed));
    _refreshPreviews();
  }

  void selectRecurring(bool isRecurring) {
    emit(state.copyWith(isRecurring: isRecurring));
    _refreshPreviews();
  }

  void selectFrequency(Frequency frequency) {
    emit(state.copyWith(frequency: frequency));
    _refreshPreviews();
  }

  void changeDate(DateTime date) {
    emit(state.copyWith(date: date.dateOnly));
    _refreshPreviews();
  }

  void selectCategory(String categoryKey) {
    emit(state.copyWith(categoryKey: categoryKey, isCategoryTouched: true));
    _refreshPreviews();
  }

  void toggleLabel(String label) {
    final labels = state.labels.contains(label)
        ? state.labels.where((l) => l != label).toList()
        : [...state.labels, label];
    emit(state.copyWith(labels: labels));
  }

  Future<void> addLabel(String label) async {
    final added = await _addLabel(label);
    if (added == null || isClosed) return;
    emit(state.copyWith(knownLabels: _getLabels(), labels: {...state.labels, added}.toList()));
  }

  Future<void> save() async {
    final amount = state.amount;
    if (amount == null || state.status != ExpenseEditorStatus.editing) return;
    emit(state.copyWith(status: ExpenseEditorStatus.saving));
    final outcome = await _saveEntry(
      ExpenseEntry(
        name: state.name,
        amount: amount,
        date: state.date,
        categoryKey: state.categoryKey,
        labels: state.labels,
        isRecurring: state.isRecurring,
        frequency: state.frequency,
        expense: state.target.expense,
        recurrence: state.target.recurrence,
      ),
    );
    if (!isClosed) emit(state.copyWith(status: ExpenseEditorStatus.saved, outcome: outcome));
  }

  Future<void> delete() async {
    await _deleteEntry(expense: state.target.expense, recurrence: state.target.recurrence);
    if (!isClosed) emit(state.copyWith(status: ExpenseEditorStatus.deleted));
  }

  void _reload() {
    if (isClosed) return;
    emit(
      state.copyWith(
        today: _clock.today(),
        knownLabels: _getLabels(),
        categories: _getCategories(),
        categoryStats: _computeStats().categoryOf(state.categoryKey),
      ),
    );
  }

  void _refreshPreviews() {
    final name = state.name.trim();
    final hasStaleStats = state.categoryStats?.categoryKey != state.categoryKey;
    emit(
      state.copyWith(
        roundUpPreview: _previewRoundUp(
          amount: state.amount,
          isRecurring: state.isRecurring || state.target.recurrence != null,
          original: state.target.expense,
        ),
        look: () => name.isEmpty ? null : _lookUpMerchant(state.name, state.categoryKey),
        nextOccurrence: () => _previewNextOccurrence(frequency: state.frequency, start: state.date),
        categoryStats: hasStaleStats ? _computeStats().categoryOf(state.categoryKey) : null,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
