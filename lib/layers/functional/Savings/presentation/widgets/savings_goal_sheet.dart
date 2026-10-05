import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_button.dart';
import 'package:depenses/layers/technical/Theme/app_sheet.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_text_field.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/goal.dart';
import '../cubit/savings_goals_cubit.dart';
import '../l10n/savings_locale.dart';
import 'savings_goal_sheet_result.dart';

class SavingsGoalSheet extends StatefulWidget {
  const SavingsGoalSheet({super.key, this.goal});

  final Goal? goal;

  static Future<void> edit(BuildContext context, {Goal? goal}) async {
    final cubit = context.read<SavingsGoalsCubit>();
    final fallbackName = context.tr(SavingsLocale.defaultGoalName);
    final result = await AppSheet.show<SavingsGoalSheetResult>(
      context,
      title: context.tr(goal == null ? SavingsLocale.newGoalTitle : SavingsLocale.editGoalTitle),
      closeLabel: context.tr(SavingsLocale.close),
      builder: (_) => SavingsGoalSheet(goal: goal),
    );
    switch (result) {
      case SavingsGoalDeleted() when goal != null:
        await cubit.delete(goal);
      case SavingsGoalSaved(:final name, :final target, :final saved, :final monthly):
        await cubit.save(
          existing: goal,
          name: name,
          target: target,
          saved: saved,
          monthly: monthly,
          fallbackName: fallbackName,
        );
      default:
        return;
    }
  }

  @override
  State<SavingsGoalSheet> createState() => _SavingsGoalSheetState();
}

class _SavingsGoalSheetState extends State<SavingsGoalSheet> {
  late final TextEditingController _name = TextEditingController(text: widget.goal?.name ?? '');
  final TextEditingController _target = TextEditingController();
  final TextEditingController _saved = TextEditingController();
  final TextEditingController _monthly = TextEditingController();
  bool _isFilled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final goal = widget.goal;
    if (goal == null || _isFilled) return;
    _isFilled = true;
    final money = context.money;
    _target.text = money.inputText(goal.target);
    _saved.text = money.inputText(goal.saved);
    _monthly.text = money.inputText(goal.monthly);
  }

  @override
  void dispose() {
    _name.dispose();
    _target.dispose();
    _saved.dispose();
    _monthly.dispose();
    super.dispose();
  }

  void _save() {
    final money = context.money;
    Navigator.of(context).pop(
      SavingsGoalSaved(
        name: _name.text,
        target: money.parse(_target.text) ?? 0,
        saved: money.parse(_saved.text) ?? 0,
        monthly: money.parse(_monthly.text) ?? 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(context.tr(SavingsLocale.nameField), controller: _name, hint: context.tr(SavingsLocale.nameHint)),
        const SizedBox(height: 14),
        AppTextField.number(
          context.tr(SavingsLocale.targetField),
          controller: _target,
          hint: context.tr(SavingsLocale.targetHint),
        ),
        const SizedBox(height: 14),
        AppTextField.number(
          context.tr(SavingsLocale.savedField),
          controller: _saved,
          hint: context.tr(SavingsLocale.savedHint),
        ),
        const SizedBox(height: 14),
        AppTextField.number(
          context.tr(SavingsLocale.monthlyField),
          controller: _monthly,
          hint: context.tr(SavingsLocale.monthlyHint),
        ),
        const SizedBox(height: AppSpacing.xl),
        AppButton.primary(context.tr(SavingsLocale.save), onTap: _save),
        if (widget.goal != null) ...[
          const SizedBox(height: 10),
          AppButton.secondary(
            context.tr(SavingsLocale.deleteGoal),
            color: context.tokens.warn,
            onTap: () => Navigator.of(context).pop(const SavingsGoalDeleted()),
          ),
        ],
      ],
    );
  }
}
