import 'package:depenses/layers/functional/Budget/domain/entities/category_envelope.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_button.dart';
import 'package:depenses/layers/technical/Theme/app_sheet.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/budget_cubit.dart';
import '../l10n/budget_locale.dart';
import 'budget_envelope_input_row.dart';

class BudgetEnvelopesSheet extends StatefulWidget {
  const BudgetEnvelopesSheet({super.key, required this.envelopes});

  final List<CategoryEnvelope> envelopes;

  static Future<void> open(BuildContext context) async {
    final cubit = context.read<BudgetCubit>();
    final amounts = await AppSheet.show<Map<String, double>>(
      context,
      title: context.tr(BudgetLocale.envelopesSheetTitle),
      closeLabel: context.tr(BudgetLocale.close),
      builder: (_) => BudgetEnvelopesSheet(envelopes: cubit.state.categoryEnvelopes),
    );
    if (amounts != null) await cubit.setEnvelopes(amounts);
  }

  @override
  State<BudgetEnvelopesSheet> createState() => _BudgetEnvelopesSheetState();
}

class _BudgetEnvelopesSheetState extends State<BudgetEnvelopesSheet> {
  late final Map<String, TextEditingController> _amounts = {
    for (final envelope in widget.envelopes)
      envelope.category.key: TextEditingController(text: envelope.hasEnvelope ? '${envelope.budget.round()}' : ''),
  };

  @override
  void dispose() {
    for (final controller in _amounts.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.tr(BudgetLocale.envelopesSheetIntro),
          style: tokens.ts(13, tokens.wBody, tokens.muted).copyWith(height: 1.4),
        ),
        const SizedBox(height: AppSpacing.md),
        for (final envelope in widget.envelopes)
          BudgetEnvelopeInputRow(category: envelope.category, controller: _amounts[envelope.category.key]!),
        const SizedBox(height: 18),
        AppButton.primary(context.tr(BudgetLocale.save), onTap: () => Navigator.of(context).pop(_parsedAmounts())),
      ],
    );
  }

  Map<String, double> _parsedAmounts() => {
    for (final entry in _amounts.entries) entry.key: context.money.parse(entry.value.text) ?? 0,
  };
}
