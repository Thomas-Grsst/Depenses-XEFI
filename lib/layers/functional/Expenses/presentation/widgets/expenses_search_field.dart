import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_icon.dart';
import 'package:depenses/layers/technical/Theme/app_pressable.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/expenses_cubit.dart';
import '../l10n/expenses_locale.dart';

class ExpensesSearchField extends StatefulWidget {
  const ExpensesSearchField({super.key});

  @override
  State<ExpensesSearchField> createState() => _ExpensesSearchFieldState();
}

class _ExpensesSearchFieldState extends State<ExpensesSearchField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    context.read<ExpensesCubit>().search('');
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isGraphite = tokens.isGraphite;
    return Container(
      height: isGraphite ? 44 : 48,
      padding: isGraphite ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 14),
      decoration: isGraphite
          ? BoxDecoration(
              border: Border(bottom: BorderSide(color: tokens.lineStrong)),
            )
          : BoxDecoration(color: tokens.card, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          AppIcon('search', size: 18, color: tokens.muted),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: context.read<ExpensesCubit>().search,
              style: tokens.ts(15, tokens.wBody),
              decoration: InputDecoration.collapsed(
                hintText: context.tr(isGraphite ? ExpensesLocale.searchHintPlain : ExpensesLocale.searchHint),
                hintStyle: tokens.ts(15, tokens.wBody, tokens.faint),
              ),
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _controller,
            builder: (context, value, _) => value.text.isEmpty
                ? const SizedBox.shrink()
                : AppPressable(
                    onTap: _clear,
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: AppIcon('close', size: 16, color: tokens.muted),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
