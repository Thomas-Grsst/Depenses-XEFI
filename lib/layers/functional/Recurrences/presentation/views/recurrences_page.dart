import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../cubit/recurrences_cubit.dart';
import 'recurrences_view.dart';

class RecurrencesPage extends StatelessWidget {
  const RecurrencesPage({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocProvider(create: (_) => GetIt.I<RecurrencesCubit>(), child: const RecurrencesView());
}
