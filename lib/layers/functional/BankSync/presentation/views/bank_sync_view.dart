import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_back_header.dart';
import 'package:depenses/layers/technical/Theme/app_page_list.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:depenses/layers/technical/Theme/show_app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/bank_balance_cubit.dart';
import '../cubit/bank_sync_cubit.dart';
import '../cubit/bank_sync_failure.dart';
import '../cubit/bank_sync_state.dart';
import '../l10n/bank_sync_locale.dart';
import '../l10n/bank_sync_messages.dart';
import '../widgets/bank_balance_banner.dart';
import '../widgets/bank_link_prompt.dart';
import '../widgets/bank_linked_accounts.dart';
import '../widgets/bank_not_configured_notice.dart';
import '../widgets/bank_sync_failure_notice.dart';

class BankSyncView extends StatelessWidget {
  const BankSyncView({super.key});

  static bool _hasFinishedSync(BankSyncState previous, BankSyncState current) =>
      previous.isSynchronizing && !current.isSynchronizing && current.report != null;

  @override
  Widget build(BuildContext context) {
    final isBankBalanceWorthAligning = context.watch<BankBalanceCubit>().state.isWorthAligning;
    return Scaffold(
      backgroundColor: context.tokens.bg,
      body: BlocConsumer<BankSyncCubit, BankSyncState>(
        listenWhen: _hasFinishedSync,
        listener: (context, state) => showAppToast(context, context.syncReportMessage(state.report!)),
        builder: (context, state) => AppPageList(
          children: [
            AppBackHeader(context.tr(BankSyncLocale.title), backLabel: context.tr(BankSyncLocale.back)),
            if (!state.isAvailable)
              const BankNotConfiguredNotice()
            else ...[
              if (state.failure != BankSyncFailure.none) BankSyncFailureNotice(failure: state.failure),
              if (state.hasAccounts && isBankBalanceWorthAligning) const BankBalanceBanner(),
              if (state.hasAccounts) BankLinkedAccounts(state: state) else const BankLinkPrompt(),
            ],
          ],
        ),
      ),
    );
  }
}
