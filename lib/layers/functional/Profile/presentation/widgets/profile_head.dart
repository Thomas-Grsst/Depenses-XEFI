import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Localization/localization_locale.dart';
import 'package:depenses/layers/technical/Theme/app_icon.dart';
import 'package:depenses/layers/technical/Theme/app_pressable.dart';
import 'package:depenses/layers/technical/Theme/app_sheet.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/profile_overview.dart';
import '../cubit/profile_cubit.dart';
import '../l10n/profile_locale.dart';
import 'profile_avatar.dart';
import 'profile_details_entry.dart';
import 'profile_details_sheet.dart';

class ProfileHead extends StatelessWidget {
  const ProfileHead({super.key, required this.overview});

  final ProfileOverview overview;

  Future<void> _edit(BuildContext context) async {
    final cubit = context.read<ProfileCubit>();
    final money = context.money;
    final account = overview.account;
    final entry = await AppSheet.show<ProfileDetailsEntry>(
      context,
      title: context.tr(ProfileLocale.profileTitle),
      closeLabel: context.tr(ProfileLocale.close),
      builder: (_) => ProfileDetailsSheet(
        initial: ProfileDetailsEntry(
          name: overview.name,
          balance: account.hasBalance ? money.inputText(overview.balance) : '',
          income: account.income > 0 ? money.inputText(account.income) : '',
          payDay: account.payDay,
        ),
      ),
    );
    if (entry == null) return;
    await cubit.saveDetails(
      name: entry.name,
      income: money.parse(entry.income),
      payDay: entry.payDay,
      balance: money.parse(entry.balance),
      isBalanceBlank: entry.balance.trim().isEmpty,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final graphite = tokens.isGraphite;
    final account = overview.account;
    final payDay = account.payDay == 1 ? context.tr(LocalizationLocale.firstDayOfMonth) : '${account.payDay}';
    final subtitle = overview.hasIncome
        ? context.trWith(ProfileLocale.salaryOnDay, [context.money.wholeEuros(account.income), payDay])
        : context.tr(ProfileLocale.tapToSetIncome);
    return AppPressable(
      onTap: () => _edit(context),
      child: Row(
        children: [
          ProfileAvatar(name: overview.name),
          SizedBox(width: graphite ? 16 : 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  overview.name,
                  style: tokens
                      .ts(graphite ? 28 : 24, graphite ? FontWeight.w300 : FontWeight.w800)
                      .copyWith(letterSpacing: -0.5),
                ),
                Text(subtitle, style: tokens.ts(13, tokens.wSemi, tokens.muted)),
              ],
            ),
          ),
          AppIcon('edit', size: 18, color: tokens.muted),
        ],
      ),
    );
  }
}
