import 'package:depenses/layers/functional/Budget/domain/entities/category_envelope.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_button.dart';
import 'package:depenses/layers/technical/Theme/app_sheet.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_text_field.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/budget_cubit.dart';
import '../l10n/budget_locale.dart';
import 'budget_category_badge.dart';

class BudgetEnvelopeSheet extends StatefulWidget {
  const BudgetEnvelopeSheet({super.key, required this.envelope, required this.initialAmount});

  final CategoryEnvelope envelope;
  final String initialAmount;

  static Future<void> open(BuildContext context, CategoryEnvelope envelope) async {
    final cubit = context.read<BudgetCubit>();
    final initialAmount = envelope.hasEnvelope ? context.money.inputText(envelope.budget) : '';
    final amount = await AppSheet.show<double>(
      context,
      title: context.trWith(BudgetLocale.envelopeSheetTitle, [envelope.category.name]),
      closeLabel: context.tr(BudgetLocale.close),
      builder: (_) => BudgetEnvelopeSheet(envelope: envelope, initialAmount: initialAmount),
    );
    if (amount != null) await cubit.setEnvelope(envelope.category.key, amount);
  }

  @override
  State<BudgetEnvelopeSheet> createState() => _BudgetEnvelopeSheetState();
}

class _BudgetEnvelopeSheetState extends State<BudgetEnvelopeSheet> {
  late final TextEditingController _amount = TextEditingController(text: widget.initialAmount);

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final envelope = widget.envelope;
    final categoryName = envelope.category.name.toLowerCase();
    final question = envelope.spent > 0
        ? context.trWith(BudgetLocale.envelopeQuestionWithSpent, [categoryName, context.money.euros(envelope.spent)])
        : context.trWith(BudgetLocale.envelopeQuestion, [categoryName]);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            BudgetCategoryBadge(category: envelope.category),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: Text(question, style: tokens.ts(13, tokens.wBody, tokens.muted).copyWith(height: 1.4))),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        AppTextField.number(
          context.tr(BudgetLocale.amountPerMonth),
          controller: _amount,
          hint: context.tr(BudgetLocale.envelopeHint),
          autofocus: true,
        ),
        const SizedBox(height: AppSpacing.xl),
        AppButton.primary(
          context.tr(BudgetLocale.save),
          onTap: () => Navigator.of(context).pop(context.money.parse(_amount.text) ?? 0),
        ),
        if (envelope.hasEnvelope) ...[
          const SizedBox(height: 10),
          AppButton.secondary(
            context.tr(BudgetLocale.stopTracking),
            color: tokens.warn,
            onTap: () => Navigator.of(context).pop(0.0),
          ),
        ],
      ],
    );
  }
}
