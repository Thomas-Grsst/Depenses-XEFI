import 'package:depenses/layers/functional/Categories/domain/entities/category.dart';
import 'package:depenses/layers/functional/Categories/domain/entities/merchant_look.dart';
import 'package:depenses/layers/technical/Theme/app_icon_badge.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

class SavingsExpenseBadge extends StatelessWidget {
  const SavingsExpenseBadge({super.key, required this.look, required this.category, this.size = 40});

  final MerchantLook look;
  final Category category;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = context.tokens.swatch(category.colorIndex);
    final letter = look.letter;
    if (letter != null) return AppIconBadge.letter(letter: letter, color: color, size: size);
    return AppIconBadge(icon: look.icon ?? category.icon, color: color, size: size);
  }
}
