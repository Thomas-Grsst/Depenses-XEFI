import 'package:flutter/material.dart';

import 'app_tokens_context.dart';

class AppRuled extends StatelessWidget {
  final Widget child;
  final bool bottom;
  final double verticalPadding;

  const AppRuled({super.key, required this.child, this.bottom = false, this.verticalPadding = 14});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    if (!tokens.isGraphite) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: verticalPadding * 0.55),
        child: child,
      );
    }
    final side = BorderSide(color: tokens.line);
    return Container(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      decoration: BoxDecoration(
        border: Border(top: side, bottom: bottom ? side : BorderSide.none),
      ),
      child: child,
    );
  }
}
