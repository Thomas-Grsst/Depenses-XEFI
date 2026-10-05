import 'package:depenses/layers/functional/Categories/domain/entities/category.dart';
import 'package:depenses/layers/functional/Categories/domain/entities/merchant_look.dart';
import 'package:depenses/layers/functional/Recurrences/domain/entities/occurrence.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Navigation/app_route.dart';
import 'package:depenses/layers/technical/Navigation/open_route.dart';
import 'package:depenses/layers/technical/Theme/app_item_row.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../l10n/relative_day_long.dart';
import 'occurrence_row_leading.dart';

class OccurrenceRow extends StatelessWidget {
  const OccurrenceRow.home({
    super.key,
    required this.occurrence,
    required this.look,
    required this.category,
    required DateTime this.today,
  }) : isListLayout = false;

  const OccurrenceRow.plain({
    super.key,
    required this.occurrence,
    required this.look,
    required this.category,
    required DateTime this.today,
  }) : isListLayout = false;

  const OccurrenceRow.list({super.key, required this.occurrence, required this.look, required this.category})
    : today = null,
      isListLayout = true;

  final Occurrence occurrence;
  final MerchantLook look;
  final Category category;
  final DateTime? today;
  final bool isListLayout;

  @override
  Widget build(BuildContext context) {
    final recurrence = occurrence.recurrence;
    final day = today;
    final showsRelativeDay = context.tokens.isGraphite && !isListLayout && day != null;
    return AppItemRow(
      leading: OccurrenceRowLeading(date: occurrence.date, look: look, category: category, isListLayout: isListLayout),
      title: recurrence.name,
      subtitle: showsRelativeDay ? context.relativeDayLong(occurrence.date, today: day) : null,
      trailing: context.money.euros(recurrence.amount),
      onTap: () => openRoute<void>(context, AppRoute.editRecurrence, arguments: recurrence),
    );
  }
}
