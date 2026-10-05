import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../cubit/budget_cubit.dart';
import 'budget_view.dart';

class BudgetPage extends StatelessWidget {
  const BudgetPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(create: (_) => GetIt.I<BudgetCubit>(), child: const BudgetView());
}
