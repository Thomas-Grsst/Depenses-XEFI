import 'package:depenses/layers/functional/Recurrences/domain/entities/occurrence.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_list_section.dart';
import 'package:flutter/material.dart';

import '../cubit/merchant_badges.dart';
import '../l10n/recurrences_locale.dart';
import 'occurrence_row.dart';

class RecurrencesUpcomingSection extends StatelessWidget {
  const RecurrencesUpcomingSection({super.key, required this.occurrences, required this.badges});

  final List<Occurrence> occurrences;
  final MerchantBadges badges;

  @override
  Widget build(BuildContext context) => AppListSection(
    title: context.tr(RecurrencesLocale.upcomingTitle),
    empty: context.tr(RecurrencesLocale.nothingPlanned),
    children: [
      for (final occurrence in occurrences)
        OccurrenceRow.list(
          occurrence: occurrence,
          look: badges.lookOf(occurrence.recurrence.name, occurrence.recurrence.categoryKey),
          category: badges.categoryOf(occurrence.recurrence.categoryKey),
        ),
    ],
  );
}
