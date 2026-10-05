import 'package:depenses/layers/functional/Categories/domain/entities/category.dart';
import 'package:depenses/layers/functional/Categories/domain/entities/merchant_look.dart';
import 'package:depenses/layers/functional/Expenses/domain/entities/expense.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/goal.dart';
import '../../domain/entities/round_up_summary.dart';

enum SavingsStatus { loading, ready }

class SavingsState extends Equatable {
  const SavingsState({
    this.status = SavingsStatus.loading,
    this.isRoundUpEnabled = false,
    this.summary = const RoundUpSummary(total: 0, thisMonth: 0, available: 0),
    this.goals = const [],
    this.recentRounded = const [],
    this.looks = const {},
    this.categories = const {},
    this.fundedGoal,
  });

  final SavingsStatus status;
  final bool isRoundUpEnabled;
  final RoundUpSummary summary;
  final List<Goal> goals;
  final List<Expense> recentRounded;
  final Map<String, MerchantLook> looks;
  final Map<String, Category> categories;
  final Goal? fundedGoal;

  SavingsState copyWith({
    SavingsStatus? status,
    bool? isRoundUpEnabled,
    RoundUpSummary? summary,
    List<Goal>? goals,
    List<Expense>? recentRounded,
    Map<String, MerchantLook>? looks,
    Map<String, Category>? categories,
    Goal? fundedGoal,
  }) => SavingsState(
    status: status ?? this.status,
    isRoundUpEnabled: isRoundUpEnabled ?? this.isRoundUpEnabled,
    summary: summary ?? this.summary,
    goals: goals ?? this.goals,
    recentRounded: recentRounded ?? this.recentRounded,
    looks: looks ?? this.looks,
    categories: categories ?? this.categories,
    fundedGoal: fundedGoal ?? this.fundedGoal,
  );

  @override
  List<Object?> get props => [status, isRoundUpEnabled, summary, goals, recentRounded, looks, categories, fundedGoal];
}
