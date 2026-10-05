import 'package:depenses/layers/technical/Theme/app_page_list.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/recurrences_cubit.dart';
import '../cubit/recurrences_mode.dart';
import '../cubit/recurrences_state.dart';
import '../widgets/recurrences_calendar_body.dart';
import '../widgets/recurrences_header.dart';
import '../widgets/recurrences_list_body.dart';
import '../widgets/recurrences_mode_switch.dart';

class RecurrencesView extends StatelessWidget {
  const RecurrencesView({super.key});

  @override
  Widget build(BuildContext context) {
    final isGraphite = context.tokens.isGraphite;
    return BlocBuilder<RecurrencesCubit, RecurrencesState>(
      builder: (context, state) => AppPageList(
        gap: isGraphite ? 28 : 14,
        children: [
          RecurrencesHeader(mode: state.mode),
          if (!isGraphite) RecurrencesModeSwitch(mode: state.mode),
          if (state.mode == RecurrencesMode.list)
            RecurrencesListBody(state: state)
          else
            RecurrencesCalendarBody(state: state),
        ],
      ),
    );
  }
}
