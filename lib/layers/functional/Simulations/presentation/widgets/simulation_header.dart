import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_back_header.dart';
import 'package:depenses/layers/technical/Theme/app_pressable.dart';
import 'package:depenses/layers/technical/Theme/app_small_button.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/simulation_cubit.dart';
import '../l10n/simulations_locale.dart';

class SimulationHeader extends StatelessWidget {
  const SimulationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final cubit = context.read<SimulationCubit>();
    if (tokens.isGraphite) {
      return AppBackHeader(
        context.tr(SimulationsLocale.editorTitle),
        backLabel: context.tr(SimulationsLocale.back),
        subtitle: context.tr(SimulationsLocale.sandbox),
        trailing: AppPressable(
          onTap: cubit.reset,
          child: SizedBox(
            width: 44,
            child: Text(
              context.tr(SimulationsLocale.resetShort),
              textAlign: TextAlign.right,
              style: tokens.ts(13, FontWeight.w400, tokens.muted),
            ),
          ),
        ),
      );
    }
    return AppBackHeader(
      context.tr(SimulationsLocale.editorTitle),
      backLabel: context.tr(SimulationsLocale.back),
      subtitle: context.tr(SimulationsLocale.sandboxSubtitle),
      trailing: AppSmallButton.secondary(context.tr(SimulationsLocale.reset), onTap: cubit.reset),
    );
  }
}
