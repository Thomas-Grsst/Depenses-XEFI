import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../cubit/categories_cubit.dart';
import '../l10n/categories_locale.dart';
import '../widgets/categories_list.dart';

class CategoriesSheet extends StatelessWidget {
  const CategoriesSheet({super.key});

  @override
  Widget build(BuildContext context) => AppSheet(
    title: context.tr(CategoriesLocale.title),
    closeLabel: context.tr(CategoriesLocale.close),
    child: BlocProvider(create: (_) => GetIt.I<CategoriesCubit>(), child: const CategoriesList()),
  );
}
