import 'package:get_it/get_it.dart';

import 'data/gateways/envelope_gateway_impl.dart';
import 'data/gateways/label_envelope_gateway_impl.dart';
import 'domain/gateways/envelope_gateway.dart';
import 'domain/gateways/label_envelope_gateway.dart';
import 'domain/use_cases/add_label_envelope_use_case.dart';
import 'domain/use_cases/delete_label_envelope_use_case.dart';
import 'domain/use_cases/get_category_envelopes_use_case.dart';
import 'domain/use_cases/get_envelopes_use_case.dart';
import 'domain/use_cases/get_label_envelope_progress_use_case.dart';
import 'domain/use_cases/get_label_envelopes_use_case.dart';
import 'domain/use_cases/get_label_spent_use_case.dart';
import 'domain/use_cases/get_total_budget_use_case.dart';
import 'domain/use_cases/save_label_envelope_use_case.dart';
import 'domain/use_cases/set_envelope_use_case.dart';
import 'domain/use_cases/set_envelopes_use_case.dart';
import 'domain/use_cases/update_label_envelope_use_case.dart';
import 'presentation/cubit/budget_cubit.dart';

void registerBudgetDependencies(GetIt getIt) {
  getIt
    ..registerLazySingleton<EnvelopeGateway>(() => EnvelopeGatewayImpl(getIt()))
    ..registerLazySingleton<LabelEnvelopeGateway>(() => LabelEnvelopeGatewayImpl(getIt()))
    ..registerLazySingleton(() => GetEnvelopesUseCase(getIt()))
    ..registerLazySingleton(() => SetEnvelopeUseCase(getIt()))
    ..registerLazySingleton(() => GetTotalBudgetUseCase(getIt()))
    ..registerLazySingleton(() => GetLabelEnvelopesUseCase(getIt()))
    ..registerLazySingleton(() => AddLabelEnvelopeUseCase(getIt(), getIt()))
    ..registerLazySingleton(() => UpdateLabelEnvelopeUseCase(getIt()))
    ..registerLazySingleton(() => DeleteLabelEnvelopeUseCase(getIt()))
    ..registerLazySingleton(() => GetLabelSpentUseCase(getIt()))
    ..registerLazySingleton(() => SetEnvelopesUseCase(getIt()))
    ..registerLazySingleton(() => GetCategoryEnvelopesUseCase(getIt()))
    ..registerLazySingleton(() => GetLabelEnvelopeProgressUseCase(getIt(), getIt(), getIt()))
    ..registerLazySingleton(() => SaveLabelEnvelopeUseCase(getIt(), getIt()))
    ..registerFactory(
      () => BudgetCubit(getIt(), getIt(), getIt(), getIt(), getIt(), getIt(), getIt(), getIt(), getIt()),
    );
}
