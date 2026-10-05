import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Navigation/app_route.dart';
import 'package:depenses/layers/technical/Navigation/open_route.dart';
import 'package:depenses/layers/technical/Theme/app_button.dart';
import 'package:depenses/layers/technical/Theme/app_section_label.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/spaced.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/bank_sync_cubit.dart';
import '../cubit/bank_sync_state.dart';
import '../l10n/bank_sync_locale.dart';
import 'bank_account_tile.dart';

class BankLinkedAccounts extends StatelessWidget {
  const BankLinkedAccounts({super.key, required this.state});

  final BankSyncState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BankSyncCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: spaced([
        AppSectionLabel(context.tr(BankSyncLocale.linkedAccounts)),
        for (final overview in state.accounts) BankAccountTile(overview: overview),
        AppButton.primary(
          context.tr(state.isSynchronizing ? BankSyncLocale.synchronizing : BankSyncLocale.synchronizeNow),
          icon: 'repeat',
          onTap: state.isBusy ? null : cubit.synchronize,
        ),
        AppButton.secondary(
          context.tr(BankSyncLocale.linkAnother),
          onTap: () => openRoute<void>(context, AppRoute.bankPicker),
        ),
      ], AppSpacing.md),
    );
  }
}
