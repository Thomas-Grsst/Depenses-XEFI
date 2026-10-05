import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_callout.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:flutter/material.dart';

import '../cubit/bank_picker_state.dart';
import '../l10n/bank_sync_locale.dart';
import 'bank_callback_paste_field.dart';

class BankAuthorizationPending extends StatelessWidget {
  const BankAuthorizationPending({super.key, required this.state});

  final BankPickerState state;

  @override
  Widget build(BuildContext context) {
    final bankName = state.selectedBank?.name ?? '';
    final message = state.isAuthorizing
        ? context.trWith(BankSyncLocale.opening, [bankName])
        : context.trWith(BankSyncLocale.awaitingAuthorization, [bankName]);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppCallout.tip(parts: [(message, false)], icon: 'bell'),
        const SizedBox(height: AppSpacing.xl),
        BankCallbackPasteField(isInvalid: state.isPasteInvalid),
      ],
    );
  }
}
