import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Localization/localization_locale.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/expense_editor_cubit.dart';

class ExpenseAmountInput extends StatefulWidget {
  const ExpenseAmountInput({super.key, required this.initialText, required this.autofocus});

  final String initialText;
  final bool autofocus;

  @override
  State<ExpenseAmountInput> createState() => _ExpenseAmountInputState();
}

class _ExpenseAmountInputState extends State<ExpenseAmountInput> {
  late final _controller = TextEditingController(text: widget.initialText);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isGraphite = tokens.isGraphite;
    final size = isGraphite ? 72.0 : 52.0;
    final weight = isGraphite ? FontWeight.w300 : FontWeight.w800;
    return IntrinsicWidth(
      child: TextField(
        controller: _controller,
        autofocus: widget.autofocus,
        textAlign: TextAlign.center,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: (text) => context.read<ExpenseEditorCubit>().changeAmount(context.money.parse(text)),
        style: tokens.ts(size, weight).copyWith(letterSpacing: isGraphite ? -2.8 : -1.5, height: 1.1),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: context.money.inputText(0),
          hintStyle: tokens.ts(size, weight, tokens.off).copyWith(letterSpacing: -1.5),
          suffixText: ' ${context.tr(LocalizationLocale.currencySymbol)}',
          suffixStyle: tokens.ts(isGraphite ? 26 : 40, weight, isGraphite ? tokens.muted : tokens.ink),
          isDense: true,
        ),
      ),
    );
  }
}
