import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppPressable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final String? semanticsLabel;

  const AppPressable({super.key, required this.child, this.onTap, this.onLongPress, this.semanticsLabel});

  @override
  State<AppPressable> createState() => _AppPressableState();
}

class _AppPressableState extends State<AppPressable> {
  bool _isPressed = false;

  void _setPressed(bool value) => setState(() => _isPressed = value);

  void _handleTap() {
    HapticFeedback.selectionClick();
    widget.onTap!();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onTap == null && widget.onLongPress == null) return widget.child;
    return Semantics(
      button: true,
      label: widget.semanticsLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        onTap: widget.onTap == null ? null : _handleTap,
        onLongPress: widget.onLongPress,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 90),
          opacity: _isPressed ? 0.6 : 1,
          child: widget.child,
        ),
      ),
    );
  }
}
