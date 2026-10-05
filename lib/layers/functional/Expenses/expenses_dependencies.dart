import 'package:get_it/get_it.dart';

import 'data/gateways/expense_gateway_impl.dart';
import 'data/gateways/label_gateway_impl.dart';
import 'data/gateways/round_up_setting_gateway_impl.dart';
import 'data/gateways/silent_expense_deletion_listener.dart';
import 'domain/gateways/expense_deletion_listener.dart';
import 'domain/gateways/expense_gateway.dart';
import 'domain/gateways/label_gateway.dart';
import 'domain/gateways/round_up_setting_gateway.dart';
import 'domain/use_cases/add_expense_use_case.dart';
import 'domain/use_cases/add_label_use_case.dart';
import 'domain/use_cases/delete_expense_entry_use_case.dart';
import 'domain/use_cases/delete_expense_use_case.dart';
import 'domain/use_cases/remove_label_use_case.dart';
import 'domain/use_cases/describe_expenses_use_case.dart';
import 'domain/use_cases/filter_expenses_use_case.dart';
import 'domain/use_cases/get_all_expenses_use_case.dart';
import 'domain/use_cases/get_label_usage_use_case.dart';
import 'domain/use_cases/get_labels_use_case.dart';
import 'domain/use_cases/get_month_expenses_use_case.dart';
import 'domain/use_cases/get_monthly_spending_use_case.dart';
import 'domain/use_cases/get_months_with_data_use_case.dart';
import 'domain/use_cases/get_recent_expenses_use_case.dart';
import 'domain/use_cases/get_round_up_enabled_use_case.dart';
import 'domain/use_cases/preview_next_occurrence_use_case.dart';
import 'domain/use_cases/preview_round_up_use_case.dart';
import 'domain/use_cases/save_expense_entry_use_case.dart';
import 'domain/use_cases/set_round_up_enabled_use_case.dart';
import 'domain/use_cases/update_expense_use_case.dart';
import 'presentation/cubit/expense_editor_cubit.dart';
import 'presentation/cubit/expense_editor_target.dart';
import 'presentation/cubit/expenses_cubit.dart';

void registerExpensesDependencies(GetIt getIt) {
  getIt
    ..registerLazySingleton<ExpenseGateway>(() => ExpenseGatewayImpl(getIt()))
    ..registerLazySingleton<LabelGateway>(() => LabelGatewayImpl(getIt()))
    ..registerLazySingleton<RoundUpSettingGateway>(() => RoundUpSettingGatewayImpl(getIt()))
    ..registerLazySingleton(() => AddExpenseUseCase(getIt(), getIt(), getIt(), getIt()))
    ..registerLazySingleton(() => UpdateExpenseUseCase(getIt(), getIt(), getIt()))
    ..registerLazySingleton(
      () => DeleteExpenseUseCase(
        getIt(),
        getIt.isRegistered<ExpenseDeletionListener>()
            ? getIt<ExpenseDeletionListener>()
            : const SilentExpenseDeletionListener(),
      ),
    )
    ..registerLazySingleton(() => GetAllExpensesUseCase(getIt()))
    ..registerLazySingleton(() => GetMonthExpensesUseCase(getIt()))
    ..registerLazySingleton(() => GetRecentExpensesUseCase(getIt()))
    ..registerLazySingleton(() => GetMonthsWithDataUseCase(getIt(), getIt()))
    ..registerLazySingleton(() => GetMonthlySpendingUseCase(getIt(), getIt()))
    ..registerLazySingleton(() => GetLabelsUseCase(getIt()))
    ..registerLazySingleton(() => GetLabelUsageUseCase(getIt(), getIt()))
    ..registerLazySingleton(() => AddLabelUseCase(getIt()))
    ..registerLazySingleton(() => RemoveLabelUseCase(getIt(), getIt(), getIt()))
    ..registerLazySingleton(() => GetRoundUpEnabledUseCase(getIt()))
    ..registerLazySingleton(() => SetRoundUpEnabledUseCase(getIt()))
    ..registerLazySingleton(() => PreviewRoundUpUseCase(getIt()))
    ..registerLazySingleton(() => DescribeExpensesUseCase(getIt(), getIt()))
    ..registerLazySingleton(() => const FilterExpensesUseCase())
    ..registerLazySingleton(() => PreviewNextOccurrenceUseCase(getIt()))
    ..registerLazySingleton(() => SaveExpenseEntryUseCase(getIt(), getIt(), getIt(), getIt(), getIt()))
    ..registerLazySingleton(() => DeleteExpenseEntryUseCase(getIt(), getIt()))
    ..registerFactoryParam<ExpensesCubit, String Function(double), void>(
      (amountLabel, _) => ExpensesCubit(getIt(), getIt(), getIt(), getIt(), getIt(), getIt(), getIt(), amountLabel),
    )
    ..registerFactoryParam<ExpenseEditorCubit, ExpenseEditorTarget, void>(
      (target, _) => ExpenseEditorCubit(
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        target,
      ),
    );
}
