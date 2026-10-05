import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Navigation/app_route.dart';
import 'package:depenses/layers/technical/Navigation/open_route.dart';
import 'package:depenses/layers/technical/Theme/app_back_header.dart';
import 'package:depenses/layers/technical/Theme/app_page_list.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/bank_picker_cubit.dart';
import '../cubit/bank_picker_state.dart';
import '../cubit/bank_sync_failure.dart';
import '../l10n/bank_sync_locale.dart';
import '../widgets/bank_authorization_pending.dart';
import '../widgets/bank_directory.dart';
import '../widgets/bank_search_field.dart';
import '../widgets/bank_sync_failure_notice.dart';

class BankPickerView extends StatelessWidget {
  const BankPickerView({super.key, this.initialQuery = ''});

  final String initialQuery;

  static bool _hasNewCallback(BankPickerState previous, BankPickerState current) =>
      current.callback != null && current.callback != previous.callback;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.tokens.bg,
      body: BlocConsumer<BankPickerCubit, BankPickerState>(
        listenWhen: _hasNewCallback,
        listener: (context, state) => openRoute<void>(context, AppRoute.bankCallback, arguments: state.callback),
        builder: (context, state) => AppPageList(
          children: [
            AppBackHeader(context.tr(BankSyncLocale.pickerTitle), backLabel: context.tr(BankSyncLocale.back)),
            if (state.failure != BankSyncFailure.none) BankSyncFailureNotice(failure: state.failure),
            if (state.isAuthorizing || state.isAwaitingCallback)
              BankAuthorizationPending(state: state)
            else ...[
              BankSearchField(initialQuery: initialQuery),
              BankDirectory(state: state),
            ],
          ],
        ),
      ),
    );
  }
}
