import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../l10n/profile_locale.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final graphite = tokens.isGraphite;
    final size = graphite ? 60.0 : 56.0;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: graphite ? Colors.transparent : tokens.hero,
        shape: BoxShape.circle,
        border: graphite ? Border.all(color: tokens.lineStrong) : null,
      ),
      child: Text(
        name.isEmpty ? context.tr(ProfileLocale.unknownInitial) : name[0].toUpperCase(),
        style: tokens.ts(
          graphite ? 24 : 22,
          graphite ? FontWeight.w300 : FontWeight.w800,
          graphite ? tokens.ink : tokens.heroAccent,
        ),
      ),
    );
  }
}
