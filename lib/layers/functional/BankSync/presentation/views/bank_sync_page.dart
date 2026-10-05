import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../cubit/bank_balance_cubit.dart';
import '../cubit/bank_sync_cubit.dart';
import 'bank_sync_view.dart';

class BankSyncPage extends StatelessWidget {
  const BankSyncPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => GetIt.I<BankSyncCubit>()),
        BlocProvider(create: (_) => GetIt.I<BankBalanceCubit>()),
      ],
      child: const BankSyncView(),
    );
  }
}
