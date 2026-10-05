import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_button.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_text_field.dart';
import 'package:flutter/material.dart';

import '../l10n/simulations_locale.dart';

class SimulationNewChargeSheet extends StatefulWidget {
  const SimulationNewChargeSheet({super.key});

  @override
  State<SimulationNewChargeSheet> createState() => _SimulationNewChargeSheetState();
}

class _SimulationNewChargeSheetState extends State<SimulationNewChargeSheet> {
  final _name = TextEditingController();
  final _amount = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          context.tr(SimulationsLocale.nameLabel),
          controller: _name,
          hint: context.tr(SimulationsLocale.nameHint),
          autofocus: true,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppTextField.number(
          context.tr(SimulationsLocale.monthlyAmountLabel),
          controller: _amount,
          hint: context.tr(SimulationsLocale.monthlyAmountHint),
        ),
        const SizedBox(height: AppSpacing.xl),
        AppButton.primary(
          context.tr(SimulationsLocale.add),
          onTap: () => Navigator.pop(context, (_name.text, _amount.text)),
        ),
      ],
    );
  }
}
