import 'dart:async';

import 'package:depenses/layers/functional/Appearance/domain/entities/color_palette.dart';
import 'package:depenses/layers/functional/Appearance/domain/entities/theme_preference.dart';
import 'package:depenses/layers/functional/Appearance/domain/entities/visual_style.dart';
import 'package:depenses/layers/functional/Appearance/domain/use_cases/save_appearance_use_case.dart';
import 'package:depenses/layers/functional/Expenses/domain/use_cases/add_label_use_case.dart';
import 'package:depenses/layers/functional/Expenses/domain/use_cases/remove_label_use_case.dart';
import 'package:depenses/layers/functional/Forecast/domain/use_cases/set_alerts_enabled_use_case.dart';
import 'package:depenses/layers/functional/Recurrences/domain/use_cases/set_detection_enabled_use_case.dart';
import 'package:depenses/layers/technical/Storage/ledger_changes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/use_cases/export_expenses_csv_use_case.dart';
import '../../domain/use_cases/get_profile_overview_use_case.dart';
import '../../domain/use_cases/reset_all_data_use_case.dart';
import '../../domain/use_cases/save_profile_details_use_case.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(
    this._getOverview,
    this._saveDetails,
    this._saveAppearance,
    this._setAlertsEnabled,
    this._setDetectionEnabled,
    this._exportCsv,
    this._resetAllData,
    this._addLabel,
    this._removeLabel,
    LedgerChanges changes,
  ) : super(const ProfileState()) {
    _subscription = changes.changes.listen((_) => load());
    load();
  }

  final GetProfileOverviewUseCase _getOverview;
  final SaveProfileDetailsUseCase _saveDetails;
  final SaveAppearanceUseCase _saveAppearance;
  final SetAlertsEnabledUseCase _setAlertsEnabled;
  final SetDetectionEnabledUseCase _setDetectionEnabled;
  final ExportExpensesCsvUseCase _exportCsv;
  final ResetAllDataUseCase _resetAllData;
  final AddLabelUseCase _addLabel;
  final RemoveLabelUseCase _removeLabel;
  late final StreamSubscription<void> _subscription;

  void load() => emit(state.copyWith(status: ProfileStatus.ready, overview: _getOverview()));

  Future<void> saveDetails({
    required String name,
    required double? income,
    required int payDay,
    required double? balance,
    required bool isBalanceBlank,
  }) => _saveDetails(name: name, income: income, payDay: payDay, balance: balance, isBalanceBlank: isBalanceBlank);

  Future<void> chooseStyle(VisualStyle style) => _saveAppearance(state.overview.appearance.copyWith(style: style));

  Future<void> choosePalette(ColorPalette palette) =>
      _saveAppearance(state.overview.appearance.copyWith(palette: palette));

  Future<void> chooseThemePreference(ThemePreference preference) =>
      _saveAppearance(state.overview.appearance.copyWith(themePreference: preference));

  Future<void> setAlertsEnabled(bool isEnabled) => _setAlertsEnabled(isEnabled);

  Future<void> setDetectionEnabled(bool isEnabled) => _setDetectionEnabled(isEnabled);

  Future<String?> addLabel(String label) => _addLabel(label);

  Future<void> removeLabel(String label) => _removeLabel(label);

  void exportCsv() => emit(state.copyWith(exportedCsv: _exportCsv(), exportCount: state.exportCount + 1));

  Future<void> resetAllData() => _resetAllData();

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
