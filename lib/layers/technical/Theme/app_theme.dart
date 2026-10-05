import 'package:flutter/material.dart';

import 'app_tokens.dart';

abstract final class AppTheme {
  static ThemeData build(AppTokens tokens) {
    final graphite = tokens.isGraphite;
    final dark = tokens.isDark;
    final cursor = graphite ? tokens.fab : tokens.mint;
    final scheme = ColorScheme(
      brightness: dark ? Brightness.dark : Brightness.light,
      primary: graphite ? tokens.fab : (dark ? tokens.mint : tokens.ink),
      onPrimary: graphite ? tokens.fabInk : (dark ? tokens.onMint : tokens.card),
      secondary: tokens.mint,
      onSecondary: tokens.onMint,
      error: tokens.warn,
      onError: tokens.fabInk,
      surface: tokens.sheet,
      onSurface: tokens.ink,
    );
    return ThemeData(
      colorScheme: scheme,
      scaffoldBackgroundColor: tokens.bg,
      fontFamily: tokens.font,
      splashFactory: InkRipple.splashFactory,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: cursor,
        selectionColor: cursor.withValues(alpha: 0.3),
        selectionHandleColor: cursor,
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: tokens.sheet,
        headerBackgroundColor: graphite ? tokens.sheet : tokens.hero,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: graphite ? tokens.sheet : tokens.hero,
        contentTextStyle: TextStyle(
          fontFamily: tokens.font,
          color: graphite ? tokens.ink : tokens.heroInk,
          fontSize: 14,
        ),
        behavior: SnackBarBehavior.floating,
      ),
      extensions: [tokens],
    );
  }
}
