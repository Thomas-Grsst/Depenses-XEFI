import 'package:depenses/layers/functional/Account/presentation/views/account_page.dart';
import 'package:depenses/layers/functional/Budget/presentation/views/budget_envelope_route_sheet.dart';
import 'package:depenses/layers/functional/Budget/presentation/views/budget_page.dart';
import 'package:depenses/layers/functional/Categories/domain/entities/category.dart';
import 'package:depenses/layers/functional/Categories/presentation/views/categories_sheet.dart';
import 'package:depenses/layers/functional/Categories/presentation/views/category_editor_sheet.dart';
import 'package:depenses/layers/functional/Expenses/domain/entities/expense.dart';
import 'package:depenses/layers/functional/Expenses/presentation/views/expense_editor_page.dart';
import 'package:depenses/layers/functional/Forecast/presentation/views/compare_page.dart';
import 'package:depenses/layers/functional/Forecast/presentation/views/forecast_page.dart';
import 'package:depenses/layers/functional/Recurrences/domain/entities/recurrence.dart';
import 'package:depenses/layers/functional/Savings/presentation/views/savings_page.dart';
import 'package:depenses/layers/functional/Simulations/domain/entities/scenario.dart';
import 'package:depenses/layers/functional/Simulations/presentation/views/simulation_page.dart';
import 'package:depenses/layers/functional/Simulations/presentation/views/simulations_page.dart';
import 'package:depenses/layers/technical/Navigation/app_route.dart';
import 'package:depenses/layers/technical/Theme/app_tokens.dart';
import 'package:flutter/material.dart';

const _graphiteBarrier = Color(0xB3000000);
const _mentheBarrier = Color(0x80040C09);

class AppRouter {
  const AppRouter(this.tokens);

  final AppTokens tokens;

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final route = AppRoute.fromPath(settings.name);
    if (route == null) return null;
    final arguments = settings.arguments;
    return switch (route) {
      AppRoute.newExpense => _page(settings, const ExpenseEditorPage()),
      AppRoute.editExpense => _page(settings, ExpenseEditorPage(expense: arguments! as Expense)),
      AppRoute.newRecurrence => _page(settings, const ExpenseEditorPage(startsRecurring: true)),
      AppRoute.editRecurrence => _page(settings, ExpenseEditorPage(recurrence: arguments! as Recurrence)),
      AppRoute.budget => _page(settings, const BudgetPage()),
      AppRoute.forecast => _page(settings, const ForecastPage()),
      AppRoute.compare => _page(settings, const ComparePage()),
      AppRoute.account => _page(settings, const AccountPage()),
      AppRoute.roundUp => _page(settings, const SavingsPage()),
      AppRoute.simulations => _page(settings, const SimulationsPage()),
      AppRoute.simulation => _page(settings, SimulationPage(scenario: arguments as Scenario?)),
      AppRoute.categories => _sheet(settings, const CategoriesSheet()),
      AppRoute.newCategory => _sheet(settings, const CategoryEditorSheet()),
      AppRoute.editCategory => _sheet(settings, CategoryEditorSheet(category: arguments! as Category)),
      AppRoute.editEnvelope => _sheet(settings, BudgetEnvelopeRouteSheet(categoryKey: arguments! as String)),
    };
  }

  Route<dynamic> _page(RouteSettings settings, Widget page) =>
      MaterialPageRoute<dynamic>(settings: settings, builder: (_) => page);

  Route<dynamic> _sheet(RouteSettings settings, Widget sheet) => ModalBottomSheetRoute<dynamic>(
    settings: settings,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    modalBarrierColor: tokens.isGraphite ? _graphiteBarrier : _mentheBarrier,
    builder: (_) => sheet,
  );
}
