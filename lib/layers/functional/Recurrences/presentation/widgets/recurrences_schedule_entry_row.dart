import 'package:depenses/layers/functional/Recurrences/domain/entities/schedule_entry.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_item_row.dart';
import 'package:depenses/layers/technical/Theme/app_mark_icon.dart';
import 'package:flutter/material.dart';

import '../cubit/merchant_badges.dart';
import 'recurrences_category_badge.dart';

class RecurrencesScheduleEntryRow extends StatelessWidget {
  const RecurrencesScheduleEntryRow({super.key, required this.entry, required this.badges, required this.badgeSize});

  final ScheduleEntry entry;
  final MerchantBadges badges;
  final double badgeSize;

  @override
  Widget build(BuildContext context) => AppItemRow(
    leading: RecurrencesCategoryBadge(
      look: badges.lookOf(entry.name, entry.categoryKey),
      category: badges.categoryOf(entry.categoryKey),
      size: badgeSize,
    ),
    title: entry.name,
    titleSuffix: entry.isPlanned ? const AppMarkIcon('repeat') : null,
    trailing: context.money.euros(entry.amount),
  );
}
