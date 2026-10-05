import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Navigation/app_route.dart';
import 'package:depenses/layers/technical/Navigation/open_route.dart';
import 'package:depenses/layers/technical/Theme/app_confirm_dialog.dart';
import 'package:depenses/layers/technical/Theme/app_item_row.dart';
import 'package:depenses/layers/technical/Theme/app_panel.dart';
import 'package:depenses/layers/technical/Theme/app_small_button.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/linked_account_overview.dart';
import '../cubit/bank_sync_cubit.dart';
import '../l10n/bank_sync_locale.dart';
import '../l10n/bank_sync_messages.dart';

class BankAccountTile extends StatelessWidget {
  const BankAccountTile({super.key, required this.overview});

  final LinkedAccountOverview overview;

  Future<void> _confirmUnlink(BuildContext context) async {
    final cubit = context.read<BankSyncCubit>();
    final isConfirmed = await AppConfirmDialog.show(
      context,
      title: context.tr(BankSyncLocale.unlinkTitle),
      message: context.trWith(BankSyncLocale.unlinkMessage, [_title]),
      confirmLabel: context.tr(BankSyncLocale.unlinkConfirm),
      cancelLabel: context.tr(BankSyncLocale.cancel),
    );
    if (isConfirmed) await cubit.unlink(overview.account);
  }

  String get _title => overview.account.bankName.isEmpty ? overview.account.label : overview.account.bankName;

  String _accessText(BuildContext context) {
    final validUntil = context.bankDate(overview.account.accessValidUntil);
    if (!overview.isExpired) return context.trWith(BankSyncLocale.validUntil, [validUntil]);
    if (overview.account.isRevoked) return context.tr(BankSyncLocale.accessExpired);
    return context.trWith(BankSyncLocale.expiredOn, [validUntil]);
  }

  String _syncText(BuildContext context) {
    final lastSync = overview.account.lastSyncedAt;
    if (lastSync == null) return context.tr(BankSyncLocale.neverSynced);
    return context.trWith(BankSyncLocale.lastSync, [context.bankDate(lastSync)]);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final account = overview.account;
    return AppPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppItemRow(title: _title, subtitle: account.bankName.isEmpty ? null : account.label),
          const SizedBox(height: AppSpacing.sm),
          Text(
            _accessText(context),
            style: tokens.ts(13, tokens.wSemi, overview.isExpired ? tokens.warn : tokens.muted),
          ),
          Text(_syncText(context), style: tokens.ts(13, tokens.wBody, tokens.muted)),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              if (overview.isExpired)
                AppSmallButton.primary(
                  context.tr(BankSyncLocale.renewAccess),
                  onTap: () => openRoute<void>(context, AppRoute.bankPicker, arguments: account.bankName),
                ),
              AppSmallButton.secondary(context.tr(BankSyncLocale.unlink), onTap: () => _confirmUnlink(context)),
            ],
          ),
        ],
      ),
    );
  }
}
