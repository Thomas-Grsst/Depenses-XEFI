import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Navigation/app_route.dart';
import 'package:depenses/layers/technical/Navigation/open_route.dart';
import 'package:depenses/layers/technical/Theme/app_icon.dart';
import 'package:depenses/layers/technical/Theme/app_pressable.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../l10n/app_locale.dart';

const _mentheShadow = Color(0x470D2B24);

class ShellAddButton extends StatelessWidget {
  const ShellAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isGraphite = tokens.isGraphite;
    final size = isGraphite ? 48.0 : 56.0;
    return AppPressable(
      onTap: () => openRoute<void>(context, AppRoute.newExpense),
      semanticsLabel: context.tr(AppLocale.addExpense),
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: tokens.fab,
          shape: BoxShape.circle,
          boxShadow: isGraphite ? null : const [BoxShadow(color: _mentheShadow, blurRadius: 20, offset: Offset(0, 8))],
        ),
        child: AppIcon('plus', size: isGraphite ? 22 : 24, color: tokens.fabInk, stroke: isGraphite ? 1.8 : 2.2),
      ),
    );
  }
}
