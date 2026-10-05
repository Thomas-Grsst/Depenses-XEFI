import 'package:depenses/layers/functional/Account/presentation/cubit/account_summary_cubit.dart';
import 'package:depenses/layers/functional/Forecast/presentation/cubit/forecast_summary_cubit.dart';
import 'package:depenses/layers/functional/Savings/presentation/cubit/savings_summary_cubit.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'cubit/home_lists_cubit.dart';
import 'home_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => GetIt.I<ForecastSummaryCubit>()),
      BlocProvider(create: (_) => GetIt.I<AccountSummaryCubit>()),
      BlocProvider(create: (_) => GetIt.I<SavingsSummaryCubit>()),
      BlocProvider(create: (_) => GetIt.I<HomeListsCubit>()),
    ],
    child: const HomeView(),
  );
}
