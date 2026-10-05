import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_empty_row.dart';
import 'package:depenses/layers/technical/Theme/app_setting_group.dart';
import 'package:depenses/layers/technical/Theme/app_setting_row.dart';
import 'package:depenses/layers/technical/Theme/app_text_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/bank_picker_cubit.dart';
import '../cubit/bank_picker_state.dart';
import '../l10n/bank_sync_locale.dart';

class BankDirectory extends StatelessWidget {
  const BankDirectory({super.key, required this.state});

  final BankPickerState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BankPickerCubit>();
    return switch (state.status) {
      BankPickerStatus.loading => AppEmptyRow(context.tr(BankSyncLocale.loadingBanks)),
      BankPickerStatus.failed => Align(
        alignment: Alignment.centerLeft,
        child: AppTextLink(context.tr(BankSyncLocale.retry), onTap: () => cubit.load(query: state.query)),
      ),
      _ when state.visibleBanks.isEmpty => AppEmptyRow(context.tr(BankSyncLocale.noBankFound)),
      _ => AppSettingGroup([
        for (final bank in state.visibleBanks)
          AppSettingRow(
            bank.name,
            chevron: true,
            onTap: () => cubit.authorize(bank, returnMessage: context.tr(BankSyncLocale.returnToApp)),
          ),
      ]),
    };
  }
}
