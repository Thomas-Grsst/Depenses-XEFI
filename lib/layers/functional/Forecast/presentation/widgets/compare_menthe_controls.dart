import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_icon.dart';
import 'package:depenses/layers/technical/Theme/app_pill_chip.dart';
import 'package:depenses/layers/technical/Theme/app_pressable.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/month_comparison.dart';
import '../cubit/compare_cubit.dart';
import '../l10n/forecast_compare_locale.dart';
import 'compare_reference_sheet.dart';

class CompareMentheControls extends StatelessWidget {
  const CompareMentheControls({super.key, required this.comparison});

  final MonthComparison comparison;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Row(
      children: [
        AppPressable(
          onTap: () => CompareReferenceSheet.pick(context),
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(color: tokens.card, borderRadius: BorderRadius.circular(999)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.trWith(ForecastCompareLocale.versusReference, [
                    context.dates.monthName(comparison.referenceMonth),
                  ]),
                  style: tokens.ts(13, FontWeight.w700),
                ),
                const SizedBox(width: 6),
                AppIcon('chevD', size: 14, color: tokens.ink, stroke: 2),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        AppPillChip(
          comparison.isToDate
              ? context.trWith(ForecastCompareLocale.toDate, ['${comparison.today.day}'])
              : context.tr(ForecastCompareLocale.wholeMonth),
          selected: true,
          height: 40,
          onTap: context.read<CompareCubit>().toggleToDate,
        ),
      ],
    );
  }
}
