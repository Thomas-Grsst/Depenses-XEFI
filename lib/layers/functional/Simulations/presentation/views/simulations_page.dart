import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../cubit/simulations_cubit.dart';
import 'simulations_view.dart';

class SimulationsPage extends StatelessWidget {
  const SimulationsPage({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocProvider(create: (_) => GetIt.I<SimulationsCubit>(), child: const SimulationsView());
}
