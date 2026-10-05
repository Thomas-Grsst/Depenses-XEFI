import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_callout.dart';
import 'package:depenses/layers/technical/Theme/app_small_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/bank_balance_cubit.dart';
import '../cubit/bank_balance_state.dart';
import '../l10n/bank_sync_locale.dart';

class BankBalanceBanner extends StatelessWidget {
  const BankBalanceBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BankBalanceCubit, BankBalanceState>(
      builder: (context, state) {
        final gap = state.gap;
        if (gap == null || !state.isWorthAligning) return const SizedBox.shrink();
        return AppCallout.tip(
          icon: 'repeat',
          parts: [
            (context.trWith(BankSyncLocale.bankBalance, [context.money.euros(gap.bankBalance)]), false),
          ],
          footer: Align(
            alignment: Alignment.centerLeft,
            child: AppSmallButton.primary(
              context.tr(BankSyncLocale.useBankBalance),
              onTap: context.read<BankBalanceCubit>().align,
            ),
          ),
        );
      },
    );
  }
}
