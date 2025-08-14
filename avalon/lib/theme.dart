// lib/theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static const Color copper = Color(0xFFC09A5D);

  static const String fontTitle = 'MedievalSharp';
  static const String fontBody = 'Merriweather';

  static ThemeData medieval() {
    final base = ThemeData(
      useMaterial3: true,
      // 關鍵：讓 Scaffold 透明，避免蓋住全域背景
      scaffoldBackgroundColor: Colors.transparent,
      fontFamily: fontBody,
      visualDensity: VisualDensity.standard,
      brightness: Brightness.light,
    );

    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: copper,
        brightness: Brightness.light,
        primary: copper,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontFamily: fontTitle, color: Colors.white, fontSize: 32, height: 1.2),
        headlineMedium: TextStyle(fontFamily: fontTitle, color: Colors.white, fontSize: 26),
        titleLarge: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: Colors.white70, fontSize: 18),
        bodyLarge: TextStyle(color: Colors.white, fontSize: 16, height: 1.5),
        bodyMedium: TextStyle(color: Colors.white70, fontSize: 14, height: 1.45),
        labelLarge: TextStyle(fontFamily: fontTitle, color: Colors.white, fontSize: 18, letterSpacing: 1.1),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.12), // 木板上可讀
        border: _roundedBorder(Colors.white24),
        enabledBorder: _roundedBorder(Colors.white24),
        focusedBorder: _roundedBorder(copper),
        errorBorder: _roundedBorder(Colors.redAccent),
        focusedErrorBorder: _roundedBorder(Colors.redAccent),
        labelStyle: const TextStyle(color: Colors.white70),
        hintStyle: const TextStyle(color: Colors.white54),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
      cardTheme: CardTheme(
        color: Colors.black.withOpacity(0.24),
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: copper,
          foregroundColor: Colors.black,
          textStyle: const TextStyle(fontFamily: fontTitle, fontSize: 16, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          minimumSize: const Size(64, 44),
          elevation: 0,
        ),
      ),
    );
  }

  static OutlineInputBorder _roundedBorder(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: 1),
      borderRadius: BorderRadius.circular(12),
    );
  }
}
