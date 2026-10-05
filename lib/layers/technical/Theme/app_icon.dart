import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'app_icon_paths.dart';
import 'app_tokens_context.dart';

class AppIcon extends StatelessWidget {
  final String name;
  final double size;
  final Color? color;
  final double? stroke;

  const AppIcon(this.name, {super.key, this.size = 22, this.color, this.stroke});

  static final Map<String, String> _svgCache = {};

  static String _svg(String name, double stroke) => _svgCache.putIfAbsent(
    '$name@$stroke',
    () =>
        '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="#000" '
        'stroke-width="$stroke" stroke-linecap="round" stroke-linejoin="round">'
        '${(AppIconPaths.byName[name] ?? '').replaceAll('currentColor', '#000')}</svg>',
  );

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return SvgPicture.string(
      _svg(name, stroke ?? (tokens.isGraphite ? 1.4 : 1.8)),
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color ?? tokens.ink, BlendMode.srcIn),
    );
  }
}
