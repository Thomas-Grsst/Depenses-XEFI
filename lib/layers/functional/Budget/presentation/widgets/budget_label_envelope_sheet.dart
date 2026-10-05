import 'package:depenses/layers/functional/Budget/domain/entities/label_envelope.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_button.dart';
import 'package:depenses/layers/technical/Theme/app_section_label.dart';
import 'package:depenses/layers/technical/Theme/app_sheet.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_text_field.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/budget_cubit.dart';
import '../l10n/budget_locale.dart';
import 'budget_label_envelope_form_result.dart';
import 'budget_label_picker.dart';

class BudgetLabelEnvelopeSheet extends StatefulWidget {
  const BudgetLabelEnvelopeSheet({
    super.key,
    required this.existing,
    required this.labels,
    required this.initialAmount,
  });

  final LabelEnvelope? existing;
  final List<String> labels;
  final String initialAmount;

  static Future<void> open(BuildContext context, {LabelEnvelope? existing}) async {
    final cubit = context.read<BudgetCubit>();
    final initialAmount = existing == null ? '' : context.money.inputText(existing.amount);
    final result = await AppSheet.show<BudgetLabelEnvelopeFormResult>(
      context,
      title: context.tr(existing == null ? BudgetLocale.newLabelEnvelopeTitle : BudgetLocale.labelEnvelopeTitle),
      closeLabel: context.tr(BudgetLocale.close),
      builder: (_) =>
          BudgetLabelEnvelopeSheet(existing: existing, labels: cubit.state.labels, initialAmount: initialAmount),
    );
    if (result == null) return;
    if (result.isDeletion) {
      if (existing != null) await cubit.deleteLabelEnvelope(existing.id);
      return;
    }
    await cubit.saveLabelEnvelope(
      existing: existing,
      name: result.name,
      fallbackName: result.fallbackName,
      label: result.label,
      amount: result.amount,
    );
  }

  @override
  State<BudgetLabelEnvelopeSheet> createState() => _BudgetLabelEnvelopeSheetState();
}

class _BudgetLabelEnvelopeSheetState extends State<BudgetLabelEnvelopeSheet> {
  late final TextEditingController _name = TextEditingController(text: widget.existing?.name ?? '');
  late final TextEditingController _amount = TextEditingController(text: widget.initialAmount);
  late final ValueNotifier<String> _label = ValueNotifier(
    widget.existing?.label ?? (widget.labels.isEmpty ? '' : widget.labels.first),
  );

  @override
  void dispose() {
    _name.dispose();
    _amount.dispose();
    _label.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.tr(BudgetLocale.labelEnvelopeIntro),
          style: tokens.ts(13, tokens.wBody, tokens.muted).copyWith(height: 1.4),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppTextField(context.tr(BudgetLocale.name), controller: _name, hint: context.tr(BudgetLocale.nameHint)),
        const SizedBox(height: AppSpacing.lg),
        AppSectionLabel(context.tr(BudgetLocale.trackedLabel)),
        const SizedBox(height: AppSpacing.sm),
        BudgetLabelPicker(labels: widget.labels, selection: _label),
        const SizedBox(height: AppSpacing.lg),
        AppTextField.number(
          context.tr(BudgetLocale.amountPerMonth),
          controller: _amount,
          hint: context.tr(BudgetLocale.labelAmountHint),
        ),
        const SizedBox(height: AppSpacing.xl),
        AppButton.primary(context.tr(BudgetLocale.save), onTap: _save),
        if (widget.existing != null) ...[
          const SizedBox(height: 10),
          AppButton.secondary(
            context.tr(BudgetLocale.deleteEnvelope),
            color: tokens.warn,
            onTap: () => Navigator.of(context).pop(const BudgetLabelEnvelopeFormResult.delete()),
          ),
        ],
      ],
    );
  }

  void _save() {
    final label = _label.value;
    Navigator.of(context).pop(
      BudgetLabelEnvelopeFormResult.save(
        name: _name.text,
        fallbackName: context.trWith(BudgetLocale.defaultLabelEnvelopeName, [label]),
        label: label,
        amount: context.money.parse(_amount.text) ?? 0,
      ),
    );
  }
}
