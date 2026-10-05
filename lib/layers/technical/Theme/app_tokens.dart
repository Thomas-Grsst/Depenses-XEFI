import 'package:flutter/material.dart';

import 'app_graphite_tokens.dart';
import 'app_menthe_tokens.dart';
import 'app_ocean_tokens.dart';
import 'app_palette.dart';
import 'app_prune_tokens.dart';
import 'app_style.dart';
import 'app_terracotta_tokens.dart';

class AppTokens extends ThemeExtension<AppTokens> {
  final bool isDark, isGraphite;
  final Color bg, card, ink, muted, faint, line, lineStrong;
  final Color mint, mintSoft, mintFill, onMint;
  final Color warn, warnSoft, warnFill;
  final Color chip, fab, fabInk, hero, heroInk, heroMuted, heroAccent, heroChip;
  final Color track, grid, ghost, good, bad, off, sheet, body, accent;
  final List<Color> swatches;

  static const int customSwatchOffset = 6;

  const AppTokens({
    required this.isDark,
    required this.isGraphite,
    required this.bg,
    required this.card,
    required this.ink,
    required this.muted,
    required this.faint,
    required this.line,
    required this.lineStrong,
    required this.mint,
    required this.mintSoft,
    required this.mintFill,
    required this.onMint,
    required this.warn,
    required this.warnSoft,
    required this.warnFill,
    required this.chip,
    required this.fab,
    required this.fabInk,
    required this.hero,
    required this.heroInk,
    required this.heroMuted,
    required this.heroAccent,
    required this.heroChip,
    required this.track,
    required this.grid,
    required this.ghost,
    required this.good,
    required this.bad,
    required this.off,
    required this.sheet,
    required this.body,
    required this.accent,
    required this.swatches,
  });

  static AppTokens resolve({required AppStyle style, required AppPalette palette, required bool isDark}) {
    if (style == AppStyle.graphite) return isDark ? AppGraphiteTokens.dark : AppGraphiteTokens.light;
    return switch (palette) {
      AppPalette.menthe => isDark ? AppMentheTokens.dark : AppMentheTokens.light,
      AppPalette.ocean => isDark ? AppOceanTokens.dark : AppOceanTokens.light,
      AppPalette.prune => isDark ? AppPruneTokens.dark : AppPruneTokens.light,
      AppPalette.terracotta => isDark ? AppTerracottaTokens.dark : AppTerracottaTokens.light,
    };
  }

  String get font => isGraphite ? 'Geist' : 'Manrope';
  double get pad => isGraphite ? 24 : 20;

  FontWeight get wTitle => isGraphite ? FontWeight.w300 : FontWeight.w800;
  FontWeight get wStrong => isGraphite ? FontWeight.w400 : FontWeight.w800;
  FontWeight get wItem => isGraphite ? FontWeight.w400 : FontWeight.w700;
  FontWeight get wBody => isGraphite ? FontWeight.w400 : FontWeight.w500;
  FontWeight get wSemi => isGraphite ? FontWeight.w400 : FontWeight.w600;

  List<Color> get customSwatches => swatches.sublist(customSwatchOffset);

  Color swatch(int index) {
    if (index >= 0 && index < customSwatchOffset) return swatches[index];
    final custom = customSwatches;
    return custom[(index - customSwatchOffset) % custom.length];
  }

  TextStyle ts(double size, [FontWeight weight = FontWeight.w500, Color? color]) => TextStyle(
    fontFamily: font,
    fontSize: size,
    fontWeight: weight,
    color: color ?? ink,
    height: 1.3,
    fontFeatures: const [FontFeature.tabularFigures()],
  );

  TextStyle label([Color? color]) => isGraphite
      ? TextStyle(
          fontFamily: 'GeistMono',
          fontSize: 11,
          letterSpacing: 1.5,
          color: color ?? muted,
          fontWeight: FontWeight.w400,
          height: 1.3,
        )
      : ts(13, FontWeight.w700, color ?? muted);

  TextStyle mono(double size, [Color? color]) =>
      TextStyle(fontFamily: 'GeistMono', fontSize: size, color: color ?? ink, height: 1.3, letterSpacing: size * 0.05);

  @override
  AppTokens copyWith({
    bool? isDark,
    bool? isGraphite,
    Color? bg,
    Color? card,
    Color? ink,
    Color? muted,
    Color? faint,
    Color? line,
    Color? lineStrong,
    Color? mint,
    Color? mintSoft,
    Color? mintFill,
    Color? onMint,
    Color? warn,
    Color? warnSoft,
    Color? warnFill,
    Color? chip,
    Color? fab,
    Color? fabInk,
    Color? hero,
    Color? heroInk,
    Color? heroMuted,
    Color? heroAccent,
    Color? heroChip,
    Color? track,
    Color? grid,
    Color? ghost,
    Color? good,
    Color? bad,
    Color? off,
    Color? sheet,
    Color? body,
    Color? accent,
    List<Color>? swatches,
  }) => AppTokens(
    isDark: isDark ?? this.isDark,
    isGraphite: isGraphite ?? this.isGraphite,
    bg: bg ?? this.bg,
    card: card ?? this.card,
    ink: ink ?? this.ink,
    muted: muted ?? this.muted,
    faint: faint ?? this.faint,
    line: line ?? this.line,
    lineStrong: lineStrong ?? this.lineStrong,
    mint: mint ?? this.mint,
    mintSoft: mintSoft ?? this.mintSoft,
    mintFill: mintFill ?? this.mintFill,
    onMint: onMint ?? this.onMint,
    warn: warn ?? this.warn,
    warnSoft: warnSoft ?? this.warnSoft,
    warnFill: warnFill ?? this.warnFill,
    chip: chip ?? this.chip,
    fab: fab ?? this.fab,
    fabInk: fabInk ?? this.fabInk,
    hero: hero ?? this.hero,
    heroInk: heroInk ?? this.heroInk,
    heroMuted: heroMuted ?? this.heroMuted,
    heroAccent: heroAccent ?? this.heroAccent,
    heroChip: heroChip ?? this.heroChip,
    track: track ?? this.track,
    grid: grid ?? this.grid,
    ghost: ghost ?? this.ghost,
    good: good ?? this.good,
    bad: bad ?? this.bad,
    off: off ?? this.off,
    sheet: sheet ?? this.sheet,
    body: body ?? this.body,
    accent: accent ?? this.accent,
    swatches: swatches ?? this.swatches,
  );

  @override
  AppTokens lerp(covariant ThemeExtension<AppTokens>? other, double t) {
    if (other is! AppTokens) return this;
    return t < 0.5 ? this : other;
  }
}
