import 'package:depenses/layers/functional/Categories/domain/entities/category.dart';
import 'package:depenses/layers/functional/Categories/domain/entities/merchant_look.dart';
import 'package:depenses/layers/technical/Theme/app_icon_badge.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

class ExpenseBadge extends StatelessWidget {
  const ExpenseBadge({super.key, required this.category, required this.look, this.size = 40, this.selected = false});

  ExpenseBadge.category({super.key, required this.category, this.size = 40, this.selected = false})
    : look = MerchantLook.icon(category.icon);

  final Category category;
  final MerchantLook look;
  final double size;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final color = context.tokens.swatch(category.colorIndex);
    final letter = look.letter;
    if (letter != null) return AppIconBadge.letter(letter: letter, color: color, size: size, selected: selected);
    return AppIconBadge(icon: look.icon!, color: color, size: size, selected: selected);
  }
}
