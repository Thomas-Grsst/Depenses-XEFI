import 'package:depenses/layers/technical/Theme/app_tokens.dart';
import 'package:flutter/material.dart';

const _heroWarmTone = Color(0xFFF5B47A);

class ForecastHeroColors {
  ForecastHeroColors(AppTokens tokens, {required bool isAccountHero})
    : background = isAccountHero ? tokens.card : tokens.hero,
      ink = isAccountHero ? tokens.ink : tokens.heroInk,
      muted = isAccountHero ? tokens.muted : tokens.heroMuted,
      accent = isAccountHero ? tokens.mintFill : tokens.heroAccent,
      rising = isAccountHero ? tokens.warn : _heroWarmTone,
      falling = isAccountHero ? tokens.mint : tokens.heroAccent,
      fallingBackground = isAccountHero ? tokens.mintSoft : tokens.heroChip,
      track = isAccountHero ? tokens.track : tokens.heroInk.withValues(alpha: 0.14);

  final Color background;
  final Color ink;
  final Color muted;
  final Color accent;
  final Color rising;
  final Color falling;
  final Color fallingBackground;
  final Color track;
}
