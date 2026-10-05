import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_button.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_text_field.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/account_cubit.dart';
import '../l10n/account_locale.dart';
import 'account_pay_day_picker.dart';

class AccountForm extends StatefulWidget {
  const AccountForm({super.key, required this.incomeText, required this.balanceText, required this.payDay});

  final String incomeText;
  final String balanceText;
  final int payDay;

  @override
  State<AccountForm> createState() => _AccountFormState();
}

class _AccountFormState extends State<AccountForm> {
  late final TextEditingController _balance = TextEditingController(text: widget.balanceText);
  late final TextEditingController _income = TextEditingController(text: widget.incomeText);

  @override
  void dispose() {
    _balance.dispose();
    _income.dispose();
    super.dispose();
  }

  void _save() {
    final money = context.money;
    context.read<AccountCubit>().save(
      income: money.parse(_income.text) ?? 0,
      balance: money.parse(_balance.text),
      isBalanceCleared: _balance.text.trim().isEmpty,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField.number(
          context.tr(AccountLocale.balanceField),
          controller: _balance,
          hint: context.tr(AccountLocale.balanceHint),
        ),
        const SizedBox(height: 6),
        Text(
          context.tr(AccountLocale.balanceHelp),
          style: tokens.ts(12, tokens.wSemi, tokens.muted).copyWith(height: 1.4),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppTextField.number(
          context.tr(AccountLocale.incomeField),
          controller: _income,
          hint: context.tr(AccountLocale.incomeHint),
        ),
        const SizedBox(height: AppSpacing.lg),
        AccountPayDayPicker(value: widget.payDay, onChanged: context.read<AccountCubit>().selectPayDay),
        const SizedBox(height: AppSpacing.xl),
        AppButton.primary(context.tr(AccountLocale.save), onTap: _save),
      ],
    );
  }
}
