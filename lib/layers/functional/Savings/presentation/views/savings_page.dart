import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../cubit/savings_cubit.dart';
import 'savings_view.dart';

class SavingsPage extends StatelessWidget {
  const SavingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => GetIt.I<SavingsCubit>(), child: const SavingsView());
  }
}
