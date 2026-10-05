import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:depenses/layers/technical/Theme/spaced.dart';
import 'package:flutter/material.dart';

import '../cubit/recurrences_state.dart';
import 'recurrence_suggestion_card.dart';
import 'recurrences_all_section.dart';
import 'recurrences_empty_panel.dart';
import 'recurrences_key_figures.dart';
import 'recurrences_upcoming_section.dart';

class RecurrencesListBody extends StatelessWidget {
  const RecurrencesListBody({super.key, required this.state});

  final RecurrencesState state;

  @override
  Widget build(BuildContext context) {
    final suggestion = state.suggestion;
    final suggestionCard = suggestion == null
        ? null
        : RecurrenceSuggestionCard(
            suggestion: suggestion,
            look: state.badges.lookOf(suggestion.name, suggestion.categoryKey),
            category: state.badges.categoryOf(suggestion.categoryKey),
          );
    final children = state.hasRecurrences
        ? [
            RecurrencesKeyFigures(
              fixedMonthly: state.fixedMonthly,
              remainingThisMonth: state.remainingThisMonth,
              month: state.currentSchedule?.month,
            ),
            ?suggestionCard,
            RecurrencesUpcomingSection(occurrences: state.nextOccurrences, badges: state.badges),
            RecurrencesAllSection(recurrences: state.recurrences, badges: state.badges),
          ]
        : [?suggestionCard, const RecurrencesEmptyPanel()];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: spaced(children, context.tokens.isGraphite ? 28 : 14),
    );
  }
}
