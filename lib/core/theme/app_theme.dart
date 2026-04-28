import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF1A237E);
  static const Color primaryLight = Color(0xFF0D47A1);

  static ThemeData get theme => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
    ),
    useMaterial3: true,
    cardTheme: CardThemeData(        // ← ganti CardTheme jadi CardThemeData
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    ),
  );
}