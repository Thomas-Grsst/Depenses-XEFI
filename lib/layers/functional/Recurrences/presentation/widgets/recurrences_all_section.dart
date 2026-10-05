import 'package:depenses/layers/functional/Recurrences/domain/entities/recurrence.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Navigation/app_route.dart';
import 'package:depenses/layers/technical/Navigation/open_route.dart';
import 'package:depenses/layers/technical/Theme/app_item_row.dart';
import 'package:depenses/layers/technical/Theme/app_list_section.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../cubit/merchant_badges.dart';
import '../l10n/recurrence_schedule_label.dart';
import '../l10n/recurrences_locale.dart';
import 'recurrences_category_badge.dart';

class RecurrencesAllSection extends StatelessWidget {
  const RecurrencesAllSection({super.key, required this.recurrences, required this.badges});

  final List<Recurrence> recurrences;
  final MerchantBadges badges;

  @override
  Widget build(BuildContext context) {
    final isGraphite = context.tokens.isGraphite;
    return AppListSection(
      title: context.tr(isGraphite ? RecurrencesLocale.allShort : RecurrencesLocale.all),
      action: context.tr(RecurrencesLocale.add),
      onAction: () => openRoute<void>(context, AppRoute.newRecurrence),
      children: [
        for (final recurrence in recurrences)
          AppItemRow(
            leading: RecurrencesCategoryBadge(
              look: badges.lookOf(recurrence.name, recurrence.categoryKey),
              category: badges.categoryOf(recurrence.categoryKey),
              size: isGraphite ? 38 : 42,
            ),
            title: recurrence.name,
            subtitle: context.scheduleOf(recurrence),
            trailing: context.money.euros(recurrence.amount),
            onTap: () => openRoute<void>(context, AppRoute.editRecurrence, arguments: recurrence),
          ),
      ],
    );
  }
}
