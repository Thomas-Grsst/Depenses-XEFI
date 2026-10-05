import 'package:flutter/material.dart';

import 'app_tokens_context.dart';
import 'spaced.dart';

class AppPageList extends StatelessWidget {
  final List<Widget> children;
  final double? gap;
  final double bottom;

  const AppPageList({super.key, required this.children, this.gap, this.bottom = 32});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: EdgeInsets.fromLTRB(tokens.pad, tokens.isGraphite ? 14 : 12, tokens.pad, bottom),
        children: spaced(children, gap ?? (tokens.isGraphite ? 28 : 14)),
      ),
    );
  }
}
