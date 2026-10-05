import 'package:depenses/layers/technical/Theme/app_icon_badge.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/merchant_badge.dart';

class SimulationsBadge extends StatelessWidget {
  const SimulationsBadge({super.key, required this.badge, this.size = 40});

  final MerchantBadge badge;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = context.tokens.swatch(badge.colorIndex);
    final letter = badge.look.letter;
    if (letter != null) return AppIconBadge.letter(letter: letter, color: color, size: size);
    return AppIconBadge(icon: badge.look.icon!, color: color, size: size);
  }
}
