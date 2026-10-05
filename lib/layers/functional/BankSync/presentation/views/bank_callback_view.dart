import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Navigation/app_route.dart';
import 'package:depenses/layers/technical/Theme/app_back_header.dart';
import 'package:depenses/layers/technical/Theme/app_page_list.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:depenses/layers/technical/Theme/show_app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/bank_callback_cubit.dart';
import '../cubit/bank_callback_state.dart';
import '../l10n/bank_sync_locale.dart';
import '../l10n/bank_sync_messages.dart';
import '../widgets/bank_callback_outcome.dart';

class BankCallbackView extends StatelessWidget {
  const BankCallbackView({super.key});

  static void returnToBankSync(BuildContext context) =>
      Navigator.of(context).pushNamedAndRemoveUntil<void>(AppRoute.bankSync.path, (route) => route.isFirst);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.tokens.bg,
      body: BlocConsumer<BankCallbackCubit, BankCallbackState>(
        listenWhen: (previous, current) => current.status == BankCallbackStatus.linked,
        listener: (context, state) {
          showAppToast(context, context.linkedAccountsMessage(state.accounts.length));
          returnToBankSync(context);
        },
        builder: (context, state) => AppPageList(
          children: [
            AppBackHeader(context.tr(BankSyncLocale.callbackTitle), backLabel: context.tr(BankSyncLocale.back)),
            BankCallbackOutcome(state: state, onDone: () => returnToBankSync(context)),
          ],
        ),
      ),
    );
  }
}
