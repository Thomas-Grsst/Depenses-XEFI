import 'package:flutter/material.dart';
import 'package:depenses/layers/technical/Theme/app_callout.dart';

import '../cubit/bank_sync_failure.dart';
import '../l10n/bank_sync_messages.dart';

class BankSyncFailureNotice extends StatelessWidget {
  const BankSyncFailureNotice({super.key, required this.failure, this.footer});

  final BankSyncFailure failure;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return AppCallout.warning(parts: [(context.bankSyncFailureMessage(failure), false)], footer: footer);
  }
}
