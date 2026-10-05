import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../cubit/bank_picker_cubit.dart';
import 'bank_picker_view.dart';

class BankPickerPage extends StatelessWidget {
  const BankPickerPage({super.key, this.initialQuery = ''});

  final String initialQuery;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<BankPickerCubit>()..load(query: initialQuery),
      child: BankPickerView(initialQuery: initialQuery),
    );
  }
}
