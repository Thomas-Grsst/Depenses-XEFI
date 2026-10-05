import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_button.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_text_field.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../l10n/profile_locale.dart';
import 'profile_details_entry.dart';
import 'profile_pay_day_picker.dart';

class ProfileDetailsSheet extends StatefulWidget {
  const ProfileDetailsSheet({super.key, required this.initial});

  final ProfileDetailsEntry initial;

  @override
  State<ProfileDetailsSheet> createState() => _ProfileDetailsSheetState();
}

class _ProfileDetailsSheetState extends State<ProfileDetailsSheet> {
  late final _name = TextEditingController(text: widget.initial.name);
  late final _balance = TextEditingController(text: widget.initial.balance);
  late final _income = TextEditingController(text: widget.initial.income);
  late final _payDay = ValueNotifier<int>(widget.initial.payDay);

  @override
  void dispose() {
    _name.dispose();
    _balance.dispose();
    _income.dispose();
    _payDay.dispose();
    super.dispose();
  }

  void _submit() => Navigator.pop(
    context,
    ProfileDetailsEntry(name: _name.text, balance: _balance.text, income: _income.text, payDay: _payDay.value),
  );

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(context.tr(ProfileLocale.firstName), controller: _name),
        const SizedBox(height: AppSpacing.lg),
        AppTextField.number(
          context.tr(ProfileLocale.balanceLabel),
          controller: _balance,
          hint: context.tr(ProfileLocale.balanceHint),
        ),
        const SizedBox(height: 6),
        Text(
          context.tr(ProfileLocale.balanceHelp),
          style: tokens.ts(12, tokens.wSemi, tokens.muted).copyWith(height: 1.4),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppTextField.number(
          context.tr(ProfileLocale.incomeLabel),
          controller: _income,
          hint: context.tr(ProfileLocale.incomeHint),
        ),
        const SizedBox(height: AppSpacing.lg),
        ValueListenableBuilder<int>(
          valueListenable: _payDay,
          builder: (context, payDay, _) =>
              ProfilePayDayPicker(value: payDay, onChanged: (value) => _payDay.value = value),
        ),
        const SizedBox(height: AppSpacing.xl),
        AppButton.primary(context.tr(ProfileLocale.save), onTap: _submit),
      ],
    );
  }
}
