import 'package:depenses/layers/functional/Account/domain/entities/account_settings.dart';
import 'package:depenses/layers/functional/Appearance/domain/entities/appearance_settings.dart';
import 'package:depenses/layers/functional/Expenses/domain/entities/label_usage.dart';
import 'package:equatable/equatable.dart';

class ProfileOverview extends Equatable {
  const ProfileOverview({
    this.name = '',
    this.account = const AccountSettings(),
    this.balance = 0,
    this.scenarioCount = 0,
    this.categoryCount = 0,
    this.labels = const [],
    this.roundUpTotal = 0,
    this.isRoundUpEnabled = true,
    this.areAlertsEnabled = true,
    this.isDetectionEnabled = true,
    this.appearance = const AppearanceSettings(),
    this.expenseCount = 0,
  });

  final String name;
  final AccountSettings account;
  final double balance;
  final int scenarioCount;
  final int categoryCount;
  final List<LabelUsage> labels;
  final double roundUpTotal;
  final bool isRoundUpEnabled;
  final bool areAlertsEnabled;
  final bool isDetectionEnabled;
  final AppearanceSettings appearance;
  final int expenseCount;

  bool get hasIncome => account.income > 0;

  bool get hasScenarios => scenarioCount > 0;

  @override
  List<Object?> get props => [
    name,
    account,
    balance,
    scenarioCount,
    categoryCount,
    labels,
    roundUpTotal,
    isRoundUpEnabled,
    areAlertsEnabled,
    isDetectionEnabled,
    appearance,
    expenseCount,
  ];
}
