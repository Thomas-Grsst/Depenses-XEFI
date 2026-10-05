import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../cubit/expenses_cubit.dart';
import 'expenses_view.dart';

class ExpensesTab extends StatelessWidget {
  const ExpensesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final amountLabel = context.money.decimals;
    return BlocProvider(
      create: (_) => GetIt.I<ExpensesCubit>(param1: amountLabel),
      child: const ExpensesView(),
    );
  }
}
