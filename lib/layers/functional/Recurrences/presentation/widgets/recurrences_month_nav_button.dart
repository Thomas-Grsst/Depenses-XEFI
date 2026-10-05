import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_icon.dart';
import 'package:depenses/layers/technical/Theme/app_pressable.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/recurrences_cubit.dart';
import '../l10n/recurrences_locale.dart';

class RecurrencesMonthNavButton extends StatelessWidget {
  const RecurrencesMonthNavButton.previous({super.key}) : isForward = false;

  const RecurrencesMonthNavButton.next({super.key}) : isForward = true;

  final bool isForward;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isGraphite = tokens.isGraphite;
    final size = isGraphite ? 44.0 : 40.0;
    return AppPressable(
      onTap: () => context.read<RecurrencesCubit>().shiftMonth(isForward ? 1 : -1),
      semanticsLabel: context.tr(isForward ? RecurrencesLocale.nextMonth : RecurrencesLocale.previousMonth),
      child: Container(
        width: size,
        height: size,
        alignment: isGraphite ? (isForward ? Alignment.centerRight : Alignment.centerLeft) : Alignment.center,
        decoration: isGraphite ? null : BoxDecoration(color: tokens.chip, shape: BoxShape.circle),
        child: AppIcon(
          isForward ? 'chevR' : 'chevL',
          size: isGraphite ? 20 : 18,
          color: isGraphite ? tokens.muted : tokens.ink,
          stroke: isGraphite ? 1.4 : 2,
        ),
      ),
    );
  }
}
