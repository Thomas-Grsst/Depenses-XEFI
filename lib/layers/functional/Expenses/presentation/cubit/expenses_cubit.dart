import 'dart:async';

import 'package:depenses/layers/functional/Categories/domain/use_cases/get_categories_use_case.dart';
import 'package:depenses/layers/technical/Calendar/calendar_day.dart';
import 'package:depenses/layers/technical/Calendar/clock.dart';
import 'package:depenses/layers/technical/Storage/ledger_changes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/expense_kind_filter.dart';
import '../../domain/entities/expense_query.dart';
import '../../domain/use_cases/describe_expenses_use_case.dart';
import '../../domain/use_cases/filter_expenses_use_case.dart';
import '../../domain/use_cases/get_month_expenses_use_case.dart';
import '../../domain/use_cases/get_monthly_spending_use_case.dart';
import 'expenses_state.dart';

class ExpensesCubit extends Cubit<ExpensesState> {
  ExpensesCubit(
    this._getMonthExpenses,
    this._describeExpenses,
    this._filterExpenses,
    this._getMonthlySpending,
    this._getCategories,
    this._clock,
    LedgerChanges changes,
    this._amountLabel,
  ) : super(ExpensesState(today: _clock.today(), month: _clock.today().firstOfMonth)) {
    _subscription = changes.changes.listen((_) => load());
    load();
  }

  final GetMonthExpensesUseCase _getMonthExpenses;
  final DescribeExpensesUseCase _describeExpenses;
  final FilterExpensesUseCase _filterExpenses;
  final GetMonthlySpendingUseCase _getMonthlySpending;
  final GetCategoriesUseCase _getCategories;
  final Clock _clock;
  final String Function(double amount) _amountLabel;
  late final StreamSubscription<void> _subscription;

  void load() {
    final monthExpenses = _describeExpenses(_getMonthExpenses(state.month));
    emit(
      state.copyWith(
        today: _clock.today(),
        months: _getMonthlySpending(),
        categories: _getCategories(),
        monthExpenses: monthExpenses,
        visibleExpenses: _filterExpenses(monthExpenses, state.query, amountLabel: _amountLabel),
      ),
    );
  }

  void selectMonth(DateTime month) {
    emit(state.copyWith(month: month.firstOfMonth));
    load();
  }

  void selectKind(ExpenseKindFilter kind) => _applyQuery(state.query.copyWith(kind: kind));

  void toggleCategory(String categoryKey) {
    final selected = state.query.categoryKey == categoryKey ? null : categoryKey;
    _applyQuery(state.query.copyWith(categoryKey: () => selected));
  }

  void search(String text) => _applyQuery(state.query.copyWith(text: text));

  void _applyQuery(ExpenseQuery query) => emit(
    state.copyWith(
      query: query,
      visibleExpenses: _filterExpenses(state.monthExpenses, query, amountLabel: _amountLabel),
    ),
  );

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
