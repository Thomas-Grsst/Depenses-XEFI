import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../domain/entities/scenario.dart';
import '../cubit/simulation_cubit.dart';
import '../cubit/simulation_state.dart';
import 'simulation_view.dart';
import 'simulations_page.dart';

class SimulationPage extends StatelessWidget {
  const SimulationPage({super.key, this.scenario});

  final Scenario? scenario;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<SimulationCubit>()..open(scenario),
      child: BlocListener<SimulationCubit, SimulationState>(
        listenWhen: (previous, current) => current.status == SimulationStatus.saved,
        listener: (context, _) =>
            Navigator.of(context).pushReplacement(MaterialPageRoute<void>(builder: (_) => const SimulationsPage())),
        child: const SimulationView(),
      ),
    );
  }
}
