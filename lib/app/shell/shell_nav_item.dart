import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_icon.dart';
import 'package:depenses/layers/technical/Theme/app_pressable.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../l10n/app_locale.dart';
import 'shell_tab.dart';
import 'shell_tab_cubit.dart';

const _itemHeight = 56.0;
const _dotSize = 4.0;

class ShellNavItem extends StatelessWidget {
  const ShellNavItem({super.key, required this.tab, required this.isSelected});

  final ShellTab tab;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final label = context.tr(AppLocale.tabLabel(tab));
    final iconColor = isSelected ? tokens.ink : (tokens.isGraphite ? tokens.faint : tokens.muted);
    return Expanded(
      child: AppPressable(
        onTap: () => context.read<ShellTabCubit>().select(tab),
        semanticsLabel: label,
        child: SizedBox(
          height: _itemHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppIcon(tab.icon, size: 22, color: iconColor),
              if (tokens.isGraphite) ...[
                const SizedBox(height: 5),
                Container(
                  width: _dotSize,
                  height: _dotSize,
                  decoration: BoxDecoration(
                    color: isSelected ? tokens.accent : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                ),
              ] else ...[
                const SizedBox(height: 3),
                Text(
                  label,
                  style: tokens.ts(
                    11,
                    isSelected ? FontWeight.w800 : FontWeight.w600,
                    isSelected ? tokens.ink : tokens.muted,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
