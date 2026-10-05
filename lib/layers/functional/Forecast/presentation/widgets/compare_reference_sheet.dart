import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_pressable.dart';
import 'package:depenses/layers/technical/Theme/app_ruled.dart';
import 'package:depenses/layers/technical/Theme/app_sheet.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/compare_cubit.dart';
import '../l10n/forecast_compare_locale.dart';

class CompareReferenceSheet extends StatelessWidget {
  const CompareReferenceSheet({super.key, required this.months});

  final List<DateTime> months;

  static Future<void> pick(BuildContext context) async {
    final cubit = context.read<CompareCubit>();
    final months = cubit.state.comparableMonths;
    if (months.isEmpty) return;
    final month = await AppSheet.show<DateTime>(
      context,
      title: context.tr(ForecastCompareLocale.compareWith),
      closeLabel: context.tr(ForecastCompareLocale.close),
      builder: (_) => CompareReferenceSheet(months: months),
    );
    if (month != null) cubit.selectReferenceMonth(month);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Column(
      children: [
        for (final month in months)
          AppRuled(
            child: AppPressable(
              onTap: () => Navigator.of(context).pop(month),
              child: SizedBox(
                height: 40,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(context.dates.monthYear(month), style: tokens.ts(16, tokens.wItem)),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
