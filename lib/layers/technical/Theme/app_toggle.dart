import 'package:flutter/material.dart';

import 'app_pressable.dart';
import 'app_tokens_context.dart';

class AppToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const AppToggle({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final graphite = tokens.isGraphite;
    final width = graphite ? 48.0 : 52.0;
    final height = graphite ? 28.0 : 32.0;
    final knobSize = graphite ? 20.0 : 26.0;
    final Color background = graphite
        ? (value ? tokens.fab : Colors.transparent)
        : (value ? tokens.mintFill : tokens.off);
    final Color knob = graphite ? (value ? Colors.white : tokens.faint) : Colors.white;
    return Semantics(
      toggled: value,
      child: AppPressable(
        onTap: () => onChanged(!value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          width: width,
          height: height,
          padding: const EdgeInsets.all(3),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(height / 2),
            border: graphite ? Border.all(color: value ? tokens.fab : tokens.lineStrong) : null,
          ),
          child: Container(
            width: knobSize,
            height: knobSize,
            decoration: BoxDecoration(
              color: knob,
              shape: BoxShape.circle,
              boxShadow: graphite
                  ? null
                  : const [BoxShadow(color: Color(0x40000000), blurRadius: 3, offset: Offset(0, 1))],
            ),
          ),
        ),
      ),
    );
  }
}
