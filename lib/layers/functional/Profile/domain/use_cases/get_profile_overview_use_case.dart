import 'package:depenses/layers/functional/Account/domain/use_cases/get_account_settings_use_case.dart';
import 'package:depenses/layers/functional/Account/domain/use_cases/get_balance_use_case.dart';
import 'package:depenses/layers/functional/Appearance/domain/use_cases/get_appearance_use_case.dart';
import 'package:depenses/layers/functional/Categories/domain/use_cases/get_categories_use_case.dart';
import 'package:depenses/layers/functional/Expenses/domain/use_cases/get_all_expenses_use_case.dart';
import 'package:depenses/layers/functional/Expenses/domain/use_cases/get_label_usage_use_case.dart';
import 'package:depenses/layers/functional/Expenses/domain/use_cases/get_round_up_enabled_use_case.dart';
import 'package:depenses/layers/functional/Forecast/domain/use_cases/get_alerts_enabled_use_case.dart';
import 'package:depenses/layers/functional/Recurrences/domain/use_cases/get_detection_enabled_use_case.dart';
import 'package:depenses/layers/functional/Simulations/domain/use_cases/get_scenarios_use_case.dart';

import '../entities/profile_overview.dart';
import 'get_profile_name_use_case.dart';

class GetProfileOverviewUseCase {
  GetProfileOverviewUseCase(
    this._name,
    this._account,
    this._balance,
    this._scenarios,
    this._categories,
    this._labels,
    this._expenses,
    this._roundUpEnabled,
    this._alertsEnabled,
    this._detectionEnabled,
    this._appearance,
  );

  final GetProfileNameUseCase _name;
  final GetAccountSettingsUseCase _account;
  final GetBalanceUseCase _balance;
  final GetScenariosUseCase _scenarios;
  final GetCategoriesUseCase _categories;
  final GetLabelUsageUseCase _labels;
  final GetAllExpensesUseCase _expenses;
  final GetRoundUpEnabledUseCase _roundUpEnabled;
  final GetAlertsEnabledUseCase _alertsEnabled;
  final GetDetectionEnabledUseCase _detectionEnabled;
  final GetAppearanceUseCase _appearance;

  ProfileOverview call() {
    final expenses = _expenses();
    return ProfileOverview(
      name: _name(),
      account: _account(),
      balance: _balance(),
      scenarioCount: _scenarios().length,
      categoryCount: _categories().length,
      labels: _labels(),
      roundUpTotal: expenses.fold(0.0, (total, e) => total + e.roundUp),
      isRoundUpEnabled: _roundUpEnabled(),
      areAlertsEnabled: _alertsEnabled(),
      isDetectionEnabled: _detectionEnabled(),
      appearance: _appearance(),
      expenseCount: expenses.length,
    );
  }
}
