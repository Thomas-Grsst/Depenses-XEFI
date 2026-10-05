import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Navigation/push_page.dart';
import 'package:depenses/layers/technical/Theme/app_back_header.dart';
import 'package:depenses/layers/technical/Theme/app_icon.dart';
import 'package:depenses/layers/technical/Theme/app_pressable.dart';
import 'package:depenses/layers/technical/Theme/app_round_button.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../l10n/simulations_locale.dart';
import '../views/simulation_page.dart';

class SimulationsHeader extends StatelessWidget {
  const SimulationsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final newLabel = context.tr(SimulationsLocale.newSimulation);
    void openEditor() => pushPage<void>(context, const SimulationPage());
    if (context.tokens.isGraphite) {
      return AppBackHeader(
        context.tr(SimulationsLocale.listTitle),
        backLabel: context.tr(SimulationsLocale.back),
        trailing: AppPressable(
          onTap: openEditor,
          semanticsLabel: newLabel,
          child: const SizedBox(
            width: 44,
            height: 44,
            child: Align(alignment: Alignment.centerRight, child: AppIcon('plus')),
          ),
        ),
      );
    }
    return AppBackHeader(
      context.tr(SimulationsLocale.listTitle),
      backLabel: context.tr(SimulationsLocale.back),
      subtitle: context.tr(SimulationsLocale.listSubtitle),
      trailing: AppRoundButton.filled('plus', semanticsLabel: newLabel, onTap: openEditor),
    );
  }
}
