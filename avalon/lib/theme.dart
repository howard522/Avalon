import 'package:flutter/material.dart';

class AppTheme {
  // 色彩定義
  static const Color parchment = Color(0xFFF3E5AB);
  static const Color inkBrown = Color(0xFF4B3621);
  static const Color copper = Color(0xFFC09A5D);
  static const Color darkWood = Color(0xFF3E2C1C);

  // 字體
  static const String fontTitle = 'MedievalSharp';
  static const String fontBody = 'Merriweather';

  static ThemeData medieval() {
    return ThemeData(
      scaffoldBackgroundColor: parchment,
      primaryColor: copper,
      fontFamily: fontBody,

      // 全域文字樣式
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontFamily: fontTitle,
          fontSize: 32,
          color: inkBrown,
        ),
        bodyLarge: TextStyle(
          color: inkBrown,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: inkBrown,
          fontSize: 14,
        ),
      ),

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: parchment,
        foregroundColor: inkBrown,
        elevation: 0,
      ),

      // ElevatedButton 樣式
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: copper,
          foregroundColor: parchment,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontFamily: fontTitle,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // Card 主題（改為 CardThemeData）
      cardTheme: CardThemeData(
        color: parchment,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: darkWood.withOpacity(0.2)),
        ),
      ),

      // ChoiceChip 主題
      chipTheme: ChipThemeData(
        backgroundColor: parchment,
        selectedColor: copper.withOpacity(0.3),
        disabledColor: parchment,
        labelStyle: const TextStyle(color: inkBrown),
        secondaryLabelStyle: const TextStyle(color: inkBrown),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: BorderSide(color: darkWood),
        ),
      ),
    );
  }
}
