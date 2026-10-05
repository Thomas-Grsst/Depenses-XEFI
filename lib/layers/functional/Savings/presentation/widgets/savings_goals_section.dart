import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../cubit/savings_goals_cubit.dart';
import 'savings_goals_list.dart';

class SavingsGoalsSection extends StatelessWidget {
  const SavingsGoalsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => GetIt.I<SavingsGoalsCubit>(), child: const SavingsGoalsList());
  }
}
