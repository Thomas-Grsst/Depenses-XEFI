import 'package:depenses/layers/technical/Localization/capitalize.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_icon.dart';
import 'package:depenses/layers/technical/Theme/app_pressable.dart';
import 'package:depenses/layers/technical/Theme/app_round_button.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/month_comparison.dart';
import '../cubit/compare_cubit.dart';
import '../l10n/forecast_compare_locale.dart';
import 'compare_reference_sheet.dart';

class CompareGraphiteHeader extends StatelessWidget {
  const CompareGraphiteHeader({super.key, required this.comparison});

  final MonthComparison comparison;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final referenceName = capitalize(context.dates.monthName(comparison.referenceMonth));
    return Row(
      children: [
        AppRoundButton(
          'chevL',
          semanticsLabel: context.tr(ForecastCompareLocale.back),
          onTap: () => Navigator.of(context).maybePop(),
        ),
        Expanded(
          child: Center(
            child: AppPressable(
              onTap: () => CompareReferenceSheet.pick(context),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.trWith(ForecastCompareLocale.versusReference, [referenceName]),
                    style: tokens.ts(15, FontWeight.w500),
                  ),
                  const SizedBox(width: 6),
                  AppIcon('chevD', size: 14, color: tokens.ink, stroke: 1.6),
                ],
              ),
            ),
          ),
        ),
        AppPressable(
          onTap: context.read<CompareCubit>().toggleToDate,
          child: SizedBox(
            width: 64,
            child: Text(
              comparison.isToDate
                  ? context.trWith(ForecastCompareLocale.toDateShort, ['${comparison.today.day}'])
                  : context.tr(ForecastCompareLocale.wholeMonthShort),
              textAlign: TextAlign.right,
              style: tokens.mono(10, tokens.muted),
            ),
          ),
        ),
      ],
    );
  }
}
