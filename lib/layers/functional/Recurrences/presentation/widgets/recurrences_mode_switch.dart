import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_segmented.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/recurrences_cubit.dart';
import '../cubit/recurrences_mode.dart';
import '../l10n/recurrences_locale.dart';

class RecurrencesModeSwitch extends StatelessWidget {
  const RecurrencesModeSwitch({super.key, required this.mode});

  final RecurrencesMode mode;

  @override
  Widget build(BuildContext context) => AppSegmented<RecurrencesMode>(
    options: [
      (RecurrencesMode.list, context.tr(RecurrencesLocale.listMode)),
      (RecurrencesMode.calendar, context.tr(RecurrencesLocale.calendarMode)),
    ],
    value: mode,
    onChanged: context.read<RecurrencesCubit>().showMode,
  );
}
