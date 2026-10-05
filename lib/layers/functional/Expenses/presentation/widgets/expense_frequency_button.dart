import 'package:depenses/layers/functional/Recurrences/domain/entities/frequency.dart';
import 'package:depenses/layers/technical/Theme/app_pressable.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/expense_editor_cubit.dart';

class ExpenseFrequencyButton extends StatelessWidget {
  const ExpenseFrequencyButton({super.key, required this.frequency, required this.label, required this.isSelected});

  final Frequency frequency;
  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isGraphite = tokens.isGraphite;
    final Color background, foreground;
    if (isGraphite) {
      background = isSelected ? tokens.fab : Colors.transparent;
      foreground = isSelected ? tokens.fabInk : tokens.ink;
    } else {
      background = isSelected ? tokens.mintSoft : tokens.chip;
      foreground = isSelected ? tokens.mint : tokens.muted;
    }
    return AppPressable(
      onTap: () => context.read<ExpenseEditorCubit>().selectFrequency(frequency),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(isGraphite ? 22 : 12),
          border: isGraphite ? Border.all(color: isSelected ? tokens.fab : tokens.lineStrong) : null,
        ),
        child: Text(label, style: tokens.ts(14, isGraphite ? FontWeight.w400 : FontWeight.w700, foreground)),
      ),
    );
  }
}
