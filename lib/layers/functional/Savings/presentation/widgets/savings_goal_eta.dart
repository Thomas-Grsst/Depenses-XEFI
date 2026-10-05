import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:flutter/widgets.dart';

import '../../domain/entities/goal.dart';
import '../l10n/savings_locale.dart';

const _monthsShownWithoutYear = 6;

String savingsGoalSubtitle(BuildContext context, Goal goal, DateTime today) {
  if (goal.remaining <= 0) return context.tr(SavingsLocale.goalReached);
  if (goal.monthly <= 0) return context.tr(SavingsLocale.goalNoMonthly);
  return context.trWith(SavingsLocale.goalPace, [
    context.money.wholeEuros(goal.monthly),
    savingsGoalEta(context, goal.monthsWith(goal.monthly), today),
  ]);
}

String savingsGoalEta(BuildContext context, int? months, DateTime today) {
  if (months == null) return context.tr(SavingsLocale.goalNever);
  if (months == 0) return context.tr(SavingsLocale.goalAchieved);
  final reached = DateTime(today.year, today.month + months);
  final monthName = context.dates.monthName(reached);
  final label = reached.year == today.year || months <= _monthsShownWithoutYear
      ? monthName
      : context.trWith(SavingsLocale.monthWithYear, [monthName, '${reached.year}']);
  return context.trWith(SavingsLocale.goalReachedIn, [label]);
}
