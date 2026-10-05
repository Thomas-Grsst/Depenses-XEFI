import 'package:depenses/layers/functional/Categories/domain/entities/category.dart';
import 'package:depenses/layers/functional/Categories/domain/gateways/category_gateway.dart';

import '../entities/budget_alert.dart';
import '../entities/category_stats.dart';
import '../entities/month_stats.dart';
import '../gateways/alert_setting_gateway.dart';

const _fastPaceMinRatio = 0.5;
const _fastPaceMinPace = 0.4;
const _fastPaceMargin = 0.15;
const _projectionTolerance = 1.05;
const _projectionMinDay = 5;

class DetectBudgetAlertsUseCase {
  DetectBudgetAlertsUseCase(this._categories, this._settings);

  final CategoryGateway _categories;
  final AlertSettingGateway _settings;

  List<BudgetAlert> call(MonthStats stats) {
    if (!_settings.isEnabled()) return const [];
    final alerts = [for (final category in _categories.all()) _alertFor(stats.categoryOf(category.key), stats)]
        .whereType<BudgetAlert>()
        .toList();
    if (stats.budget > 0 && stats.forecast > stats.budget && alerts.isEmpty) {
      alerts.add(
        BudgetAlert(
          kind: BudgetAlertKind.totalOverrun,
          categoryKey: Category.otherKey,
          overrun: stats.forecast - stats.budget,
        ),
      );
    }
    return alerts;
  }

  BudgetAlert? _alertFor(CategoryStats category, MonthStats stats) {
    if (category.budget <= 0) return null;
    final ratio = category.spent / category.budget;
    if (ratio >= 1) {
      return BudgetAlert(
        kind: BudgetAlertKind.overspent,
        categoryKey: category.categoryKey,
        spent: category.spent,
        budget: category.budget,
        ratio: ratio,
      );
    }
    final fixed = category.recurringSpent + category.remainingRecurring;
    final variable = category.budget - fixed;
    final pace = variable > 0 ? category.occasionalSpent / variable : 0.0;
    final dayRatio = stats.day / stats.daysInMonth;
    if (ratio >= _fastPaceMinRatio && pace >= _fastPaceMinPace && pace > dayRatio + _fastPaceMargin) {
      return BudgetAlert(
        kind: BudgetAlertKind.fastPace,
        categoryKey: category.categoryKey,
        ratio: ratio,
        day: stats.day,
      );
    }
    if (category.projected > category.budget * _projectionTolerance && stats.day >= _projectionMinDay) {
      return BudgetAlert(
        kind: BudgetAlertKind.projectedOverrun,
        categoryKey: category.categoryKey,
        overrun: category.projected - category.budget,
      );
    }
    return null;
  }
}
