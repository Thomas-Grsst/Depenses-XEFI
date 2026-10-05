import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:depenses/layers/technical/Theme/spaced.dart';
import 'package:flutter/material.dart';

import '../cubit/recurrences_state.dart';
import 'recurrences_calendar_panel.dart';
import 'recurrences_day_list.dart';
import 'recurrences_remaining_banner.dart';

class RecurrencesCalendarBody extends StatelessWidget {
  const RecurrencesCalendarBody({super.key, required this.state});

  final RecurrencesState state;

  @override
  Widget build(BuildContext context) {
    final schedule = state.visibleSchedule;
    if (schedule == null) return const SizedBox.shrink();
    final children = [
      RecurrencesCalendarPanel(schedule: schedule, selectedDay: state.selectedDayInView, badges: state.badges),
      RecurrencesDayList(
        day: state.selectedDayInView,
        timing: state.selectedTiming,
        entries: state.selectedEntries,
        badges: state.badges,
      ),
      if (!schedule.isOver) RecurrencesRemainingBanner(total: schedule.plannedTotal),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: spaced(children, context.tokens.isGraphite ? 28 : 14),
    );
  }
}
