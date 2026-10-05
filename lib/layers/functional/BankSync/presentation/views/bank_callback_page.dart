import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../cubit/bank_callback_cubit.dart';
import 'bank_callback_view.dart';

class BankCallbackPage extends StatelessWidget {
  const BankCallbackPage({super.key, required this.callback});

  final Uri callback;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<BankCallbackCubit>()..complete(callback),
      child: const BankCallbackView(),
    );
  }
}
