import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../cubit/budget_cubit.dart';
import '../cubit/budget_state.dart';
import '../l10n/budget_locale.dart';
import '../widgets/budget_envelope_sheet.dart';

class BudgetEnvelopeRouteSheet extends StatelessWidget {
  const BudgetEnvelopeRouteSheet({super.key, required this.categoryKey});

  final String categoryKey;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => GetIt.I<BudgetCubit>(),
    child: BlocBuilder<BudgetCubit, BudgetState>(
      builder: (context, state) {
        final envelope = state.categoryEnvelopes.where((e) => e.category.key == categoryKey).firstOrNull;
        if (envelope == null) return const SizedBox.shrink();
        final cubit = context.read<BudgetCubit>();
        return PopScope<double>(
          onPopInvokedWithResult: (didPop, amount) {
            if (didPop && amount != null) cubit.setEnvelope(categoryKey, amount);
          },
          child: AppSheet(
            title: context.trWith(BudgetLocale.envelopeSheetTitle, [envelope.category.name]),
            closeLabel: context.tr(BudgetLocale.close),
            child: BudgetEnvelopeSheet(
              envelope: envelope,
              initialAmount: envelope.hasEnvelope ? context.money.inputText(envelope.budget) : '',
            ),
          ),
        );
      },
    ),
  );
}
