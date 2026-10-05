import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Navigation/app_route.dart';
import 'package:depenses/layers/technical/Navigation/open_route.dart';
import 'package:depenses/layers/technical/Theme/app_confirm_dialog.dart';
import 'package:depenses/layers/technical/Theme/app_section_label.dart';
import 'package:depenses/layers/technical/Theme/app_setting_group.dart';
import 'package:depenses/layers/technical/Theme/app_setting_row.dart';
import 'package:depenses/layers/technical/Theme/app_toggle.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/profile_overview.dart';
import '../cubit/profile_cubit.dart';
import '../l10n/profile_locale.dart';
import 'profile_labels_sheet.dart';

class ProfileSettingsSection extends StatelessWidget {
  const ProfileSettingsSection({super.key, required this.overview});

  final ProfileOverview overview;

  Future<void> _confirmReset(BuildContext context) async {
    final cubit = context.read<ProfileCubit>();
    final isConfirmed = await AppConfirmDialog.show(
      context,
      title: context.tr(ProfileLocale.resetTitle),
      message: context.tr(ProfileLocale.resetMessage),
      confirmLabel: context.tr(ProfileLocale.resetConfirm),
      cancelLabel: context.tr(ProfileLocale.cancel),
    );
    if (isConfirmed) await cubit.resetAllData();
  }

  String _roundUpValue(BuildContext context) {
    if (overview.roundUpTotal > 0) {
      return context.trWith(ProfileLocale.roundUpTotal, [context.money.euros(overview.roundUpTotal)]);
    }
    return context.tr(overview.isRoundUpEnabled ? ProfileLocale.enabled : ProfileLocale.disabled);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final cubit = context.read<ProfileCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSectionLabel(context.tr(ProfileLocale.settings)),
        SizedBox(height: tokens.isGraphite ? 6 : 8),
        AppSettingGroup([
          AppSettingRow(
            context.tr(ProfileLocale.account),
            value: overview.account.hasBalance
                ? context.money.euros(overview.balance)
                : context.tr(ProfileLocale.toDefine),
            chevron: true,
            onTap: () => openRoute<void>(context, AppRoute.account),
          ),
          AppSettingRow(
            context.tr(ProfileLocale.budget),
            chevron: true,
            onTap: () => openRoute<void>(context, AppRoute.budget),
          ),
          AppSettingRow(
            context.tr(ProfileLocale.simulations),
            value: overview.hasScenarios ? '${overview.scenarioCount}' : null,
            chevron: true,
            onTap: () => openRoute<void>(context, overview.hasScenarios ? AppRoute.simulations : AppRoute.simulation),
          ),
          AppSettingRow(
            context.tr(ProfileLocale.categories),
            value: '${overview.categoryCount}',
            chevron: true,
            onTap: () => openRoute<void>(context, AppRoute.categories),
          ),
          AppSettingRow(
            context.tr(ProfileLocale.labels),
            value: '${overview.labels.length}',
            chevron: true,
            onTap: () => ProfileLabelsSheet.show(context),
          ),
          AppSettingRow(
            context.tr(ProfileLocale.roundUp),
            value: _roundUpValue(context),
            chevron: true,
            onTap: () => openRoute<void>(context, AppRoute.roundUp),
          ),
          AppSettingRow(
            context.tr(ProfileLocale.alerts),
            trailing: AppToggle(value: overview.areAlertsEnabled, onChanged: cubit.setAlertsEnabled),
          ),
          AppSettingRow(
            context.tr(ProfileLocale.detection),
            trailing: AppToggle(value: overview.isDetectionEnabled, onChanged: cubit.setDetectionEnabled),
          ),
          AppSettingRow(context.tr(ProfileLocale.currency), value: context.tr(ProfileLocale.currencyValue)),
          AppSettingRow(
            context.tr(ProfileLocale.export),
            value: context.tr(ProfileLocale.exportFormat),
            onTap: cubit.exportCsv,
          ),
          AppSettingRow(context.tr(ProfileLocale.reset), color: tokens.warn, onTap: () => _confirmReset(context)),
        ]),
      ],
    );
  }
}
