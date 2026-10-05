import 'package:depenses/layers/functional/Account/domain/use_cases/clear_balance_use_case.dart';
import 'package:depenses/layers/functional/Budget/domain/gateways/envelope_gateway.dart';
import 'package:depenses/layers/functional/Budget/domain/gateways/label_envelope_gateway.dart';
import 'package:depenses/layers/functional/Expenses/domain/gateways/expense_gateway.dart';
import 'package:depenses/layers/functional/Expenses/domain/gateways/round_up_setting_gateway.dart';
import 'package:depenses/layers/functional/Forecast/domain/gateways/alert_setting_gateway.dart';
import 'package:depenses/layers/functional/Recurrences/domain/gateways/detection_setting_gateway.dart';
import 'package:depenses/layers/functional/Recurrences/domain/gateways/recurrence_gateway.dart';
import 'package:depenses/layers/functional/Savings/domain/gateways/goal_gateway.dart';
import 'package:depenses/layers/functional/Savings/domain/gateways/round_up_usage_gateway.dart';
import 'package:depenses/layers/functional/Simulations/domain/gateways/scenario_gateway.dart';

class ResetAllDataUseCase {
  ResetAllDataUseCase(
    this._expenses,
    this._recurrences,
    this._envelopes,
    this._labelEnvelopes,
    this._goals,
    this._scenarios,
    this._clearBalance,
    this._alerts,
    this._detection,
    this._roundUp,
    this._roundUpUsage,
  );

  final ExpenseGateway _expenses;
  final RecurrenceGateway _recurrences;
  final EnvelopeGateway _envelopes;
  final LabelEnvelopeGateway _labelEnvelopes;
  final GoalGateway _goals;
  final ScenarioGateway _scenarios;
  final ClearBalanceUseCase _clearBalance;
  final AlertSettingGateway _alerts;
  final DetectionSettingGateway _detection;
  final RoundUpSettingGateway _roundUp;
  final RoundUpUsageGateway _roundUpUsage;

  Future<void> call() async {
    await _expenses.clear();
    await _recurrences.clear();
    await _envelopes.clear();
    await _labelEnvelopes.saveAll(const []);
    await _goals.saveAll(const []);
    await _scenarios.saveAll(const []);
    await _clearBalance();
    await _alerts.setEnabled(true);
    await _detection.reset();
    await _roundUp.setEnabled(true);
    await _roundUpUsage.setUsed(0);
  }
}
