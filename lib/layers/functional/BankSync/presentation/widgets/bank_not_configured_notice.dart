import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_callout.dart';
import 'package:flutter/material.dart';

import '../l10n/bank_sync_locale.dart';

class BankNotConfiguredNotice extends StatelessWidget {
  const BankNotConfiguredNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCallout.warning(
      parts: [
        (context.tr(BankSyncLocale.notConfiguredTitle), true),
        ('\n', false),
        (context.tr(BankSyncLocale.notConfiguredHelp), false),
        ('\n', false),
        (context.tr(BankSyncLocale.notConfiguredCommand), true),
      ],
    );
  }
}
