import 'dart:async';

import 'package:depenses/layers/functional/Budget/domain/entities/label_envelope.dart';
import 'package:depenses/layers/functional/Budget/domain/use_cases/delete_label_envelope_use_case.dart';
import 'package:depenses/layers/functional/Budget/domain/use_cases/get_category_envelopes_use_case.dart';
import 'package:depenses/layers/functional/Budget/domain/use_cases/get_label_envelope_progress_use_case.dart';
import 'package:depenses/layers/functional/Budget/domain/use_cases/save_label_envelope_use_case.dart';
import 'package:depenses/layers/functional/Budget/domain/use_cases/set_envelope_use_case.dart';
import 'package:depenses/layers/functional/Budget/domain/use_cases/set_envelopes_use_case.dart';
import 'package:depenses/layers/functional/Expenses/domain/use_cases/get_labels_use_case.dart';
import 'package:depenses/layers/functional/Forecast/domain/use_cases/compute_month_stats_use_case.dart';
import 'package:depenses/layers/technical/Storage/ledger_changes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'budget_state.dart';

class BudgetCubit extends Cubit<BudgetState> {
  BudgetCubit(
    this._computeStats,
    this._getCategoryEnvelopes,
    this._getLabelEnvelopeProgress,
    this._getLabels,
    this._setEnvelope,
    this._setEnvelopes,
    this._saveLabelEnvelope,
    this._deleteLabelEnvelope,
    LedgerChanges changes,
  ) : super(const BudgetState()) {
    _subscription = changes.changes.listen((_) => load());
    load();
  }

  final ComputeMonthStatsUseCase _computeStats;
  final GetCategoryEnvelopesUseCase _getCategoryEnvelopes;
  final GetLabelEnvelopeProgressUseCase _getLabelEnvelopeProgress;
  final GetLabelsUseCase _getLabels;
  final SetEnvelopeUseCase _setEnvelope;
  final SetEnvelopesUseCase _setEnvelopes;
  final SaveLabelEnvelopeUseCase _saveLabelEnvelope;
  final DeleteLabelEnvelopeUseCase _deleteLabelEnvelope;
  late final StreamSubscription<void> _subscription;

  void load() {
    final stats = _computeStats();
    emit(
      state.copyWith(
        stats: stats,
        categoryEnvelopes: _getCategoryEnvelopes(stats),
        labelEnvelopes: _getLabelEnvelopeProgress(),
        labels: _getLabels(),
      ),
    );
  }

  Future<void> setEnvelope(String categoryKey, double amount) => _setEnvelope(categoryKey, amount);

  Future<void> setEnvelopes(Map<String, double> amountsByCategory) => _setEnvelopes(amountsByCategory);

  Future<bool> saveLabelEnvelope({
    LabelEnvelope? existing,
    required String name,
    required String fallbackName,
    required String label,
    required double amount,
  }) => _saveLabelEnvelope(existing: existing, name: name, fallbackName: fallbackName, label: label, amount: amount);

  Future<void> deleteLabelEnvelope(String id) => _deleteLabelEnvelope(id);

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
