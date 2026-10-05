import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../cubit/forecast_cubit.dart';
import 'forecast_view.dart';

class ForecastPage extends StatelessWidget {
  const ForecastPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => GetIt.I<ForecastCubit>(), child: const ForecastView());
  }
}
