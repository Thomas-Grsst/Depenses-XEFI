import 'package:flutter/material.dart';

import 'app_pressable.dart';
import 'app_spacing.dart';
import 'app_tokens_context.dart';
import 'spaced.dart';

class AppSegmented<T> extends StatelessWidget {
  final List<(T, String)> options;
  final T value;
  final ValueChanged<T> onChanged;
  final bool center;

  const AppSegmented({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    this.center = false,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    if (tokens.isGraphite) {
      return Row(
        mainAxisAlignment: center ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: spaced([
          for (final option in options)
            _AppUnderlinedTab(label: option.$2, selected: option.$1 == value, onTap: () => onChanged(option.$1)),
        ], center ? 28 : 22),
      );
    }
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(color: tokens.chip, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          for (final option in options)
            Expanded(
              child: _AppPillTab(label: option.$2, selected: option.$1 == value, onTap: () => onChanged(option.$1)),
            ),
        ],
      ),
    );
  }
}

class _AppUnderlinedTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _AppUnderlinedTab({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return AppPressable(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 40),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: selected ? tokens.accent : Colors.transparent)),
        ),
        child: Text(label, style: tokens.ts(14, FontWeight.w400, selected ? tokens.ink : tokens.muted)),
      ),
    );
  }
}

class _AppPillTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _AppPillTab({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return AppPressable(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? tokens.card : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: selected ? const [BoxShadow(color: Color(0x1F0D2B24), blurRadius: 3, offset: Offset(0, 1))] : null,
        ),
        child: Text(
          label,
          style: tokens.ts(14, selected ? FontWeight.w800 : FontWeight.w600, selected ? tokens.ink : tokens.muted),
        ),
      ),
    );
  }
}
