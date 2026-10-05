import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import 'shell_add_button.dart';
import 'shell_nav_item.dart';
import 'shell_tab.dart';

const _barHeight = 64.0;
const _addSlotWidth = 72.0;
const _mentheAddLift = -14.0;

class ShellNavBar extends StatelessWidget {
  const ShellNavBar({super.key, required this.selected});

  final ShellTab selected;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isGraphite = tokens.isGraphite;
    final sidePadding = isGraphite ? 16.0 : 8.0;
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom, left: sidePadding, right: sidePadding),
      decoration: BoxDecoration(
        color: isGraphite ? tokens.bg : tokens.card,
        border: isGraphite ? Border(top: BorderSide(color: tokens.line)) : null,
      ),
      child: SizedBox(
        height: _barHeight,
        child: Row(
          children: [
            ShellNavItem(tab: ShellTab.home, isSelected: selected == ShellTab.home),
            ShellNavItem(tab: ShellTab.expenses, isSelected: selected == ShellTab.expenses),
            SizedBox(
              width: _addSlotWidth,
              child: Transform.translate(
                offset: Offset(0, isGraphite ? 0 : _mentheAddLift),
                child: const Center(child: ShellAddButton()),
              ),
            ),
            ShellNavItem(tab: ShellTab.recurrences, isSelected: selected == ShellTab.recurrences),
            ShellNavItem(tab: ShellTab.profile, isSelected: selected == ShellTab.profile),
          ],
        ),
      ),
    );
  }
}
