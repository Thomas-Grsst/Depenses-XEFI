import 'package:get_it/get_it.dart';

import 'data/gateways/category_gateway_impl.dart';
import 'domain/gateways/category_gateway.dart';
import 'domain/use_cases/add_category_use_case.dart';
import 'domain/use_cases/delete_category_use_case.dart';
import 'domain/use_cases/get_categories_use_case.dart';
import 'domain/use_cases/get_category_use_case.dart';
import 'domain/use_cases/guess_category_use_case.dart';
import 'domain/use_cases/look_up_merchant_use_case.dart';
import 'domain/use_cases/suggest_category_color_use_case.dart';
import 'domain/use_cases/update_category_use_case.dart';
import 'presentation/cubit/categories_cubit.dart';
import 'presentation/cubit/category_editor_cubit.dart';
import 'presentation/cubit/category_editor_target.dart';

void registerCategoriesDependencies(GetIt getIt) {
  getIt
    ..registerLazySingleton<CategoryGateway>(() => CategoryGatewayImpl(getIt()))
    ..registerLazySingleton(() => GetCategoriesUseCase(getIt()))
    ..registerLazySingleton(() => GetCategoryUseCase(getIt()))
    ..registerLazySingleton(() => AddCategoryUseCase(getIt(), getIt()))
    ..registerLazySingleton(() => UpdateCategoryUseCase(getIt()))
    ..registerLazySingleton(() => DeleteCategoryUseCase(getIt(), getIt(), getIt(), getIt()))
    ..registerLazySingleton(() => LookUpMerchantUseCase(getIt()))
    ..registerLazySingleton(() => GuessCategoryUseCase(getIt()))
    ..registerLazySingleton(() => SuggestCategoryColorUseCase(getIt()))
    ..registerFactory(() => CategoriesCubit(getIt(), getIt()))
    ..registerFactoryParam<CategoryEditorCubit, CategoryEditorTarget, void>(
      (target, _) => CategoryEditorCubit(getIt(), getIt(), getIt(), getIt(), target),
    );
}
