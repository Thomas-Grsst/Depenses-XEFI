import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_button.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/goal.dart';
import '../cubit/savings_cubit.dart';
import '../l10n/savings_locale.dart';

class SavingsMoveButtons extends StatelessWidget {
  const SavingsMoveButtons({super.key, required this.available, required this.goals});

  final double available;
  final List<Goal> goals;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SavingsCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final goal in goals) ...[
          AppButton.primary(
            context.trWith(SavingsLocale.moveTo, [context.money.euros(available), goal.name]),
            onTap: () => cubit.moveToGoal(goal),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}
