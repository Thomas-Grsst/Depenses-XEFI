import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../cubit/compare_cubit.dart';
import 'compare_view.dart';

class ComparePage extends StatelessWidget {
  const ComparePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => GetIt.I<CompareCubit>(), child: const CompareView());
  }
}
