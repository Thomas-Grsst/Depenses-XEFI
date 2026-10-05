import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_button.dart';
import 'package:depenses/layers/technical/Theme/app_text_field.dart';
import 'package:flutter/material.dart';

import '../l10n/expenses_locale.dart';

class ExpenseLabelSheet extends StatefulWidget {
  const ExpenseLabelSheet({super.key});

  @override
  State<ExpenseLabelSheet> createState() => _ExpenseLabelSheetState();
}

class _ExpenseLabelSheetState extends State<ExpenseLabelSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      AppTextField(
        context.tr(ExpensesLocale.label),
        controller: _controller,
        hint: context.tr(ExpensesLocale.labelHint),
        autofocus: true,
      ),
      const SizedBox(height: 18),
      AppButton.primary(context.tr(ExpensesLocale.add), onTap: () => Navigator.pop(context, _controller.text.trim())),
    ],
  );
}
