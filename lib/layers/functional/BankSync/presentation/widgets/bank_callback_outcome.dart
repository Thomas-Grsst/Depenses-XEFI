import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_button.dart';
import 'package:depenses/layers/technical/Theme/app_callout.dart';
import 'package:depenses/layers/technical/Theme/app_empty_row.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:flutter/material.dart';

import '../cubit/bank_callback_state.dart';
import '../l10n/bank_sync_locale.dart';
import '../l10n/bank_sync_messages.dart';

class BankCallbackOutcome extends StatelessWidget {
  const BankCallbackOutcome({super.key, required this.state, required this.onDone});

  final BankCallbackState state;
  final VoidCallback onDone;

  String _message(BuildContext context) => switch (state.status) {
    BankCallbackStatus.completing => context.tr(BankSyncLocale.completing),
    BankCallbackStatus.linked => context.linkedAccountsMessage(state.accounts.length),
    BankCallbackStatus.cancelled => context.tr(BankSyncLocale.cancelled),
    BankCallbackStatus.rejected => context.tr(BankSyncLocale.rejected),
    BankCallbackStatus.failed => context.bankSyncFailureMessage(state.failure),
  };

  @override
  Widget build(BuildContext context) {
    if (state.isCompleting) return AppEmptyRow(_message(context));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (state.status == BankCallbackStatus.linked)
          AppCallout.tip(parts: [(_message(context), false)], icon: 'check')
        else
          AppCallout.warning(parts: [(_message(context), false)]),
        const SizedBox(height: AppSpacing.lg),
        AppButton.secondary(context.tr(BankSyncLocale.backToBank), onTap: onDone),
      ],
    );
  }
}
