import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/expense_editor_cubit.dart';
import '../l10n/expenses_locale.dart';

class ExpenseNameInput extends StatefulWidget {
  const ExpenseNameInput({super.key, required this.initialText});

  final String initialText;

  @override
  State<ExpenseNameInput> createState() => _ExpenseNameInputState();
}

class _ExpenseNameInputState extends State<ExpenseNameInput> {
  late final _controller = TextEditingController(text: widget.initialText);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return TextField(
      controller: _controller,
      onChanged: context.read<ExpenseEditorCubit>().changeName,
      textCapitalization: TextCapitalization.sentences,
      style: tokens.ts(16, tokens.isGraphite ? FontWeight.w400 : FontWeight.w700),
      decoration: InputDecoration.collapsed(
        hintText: context.tr(ExpensesLocale.nameHint),
        hintStyle: tokens.ts(16, FontWeight.w400, tokens.faint),
      ),
    );
  }
}
