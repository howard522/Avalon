import 'package:flutter/material.dart';

class AppTheme {
  // 颜色配置
  static const Color parchment = Color(0xFFF3E5AB);    // 羊皮纸米黄
  static const Color inkBrown = Color(0xFF4B3621);     // 深褐墨水
  static const Color copper = Color(0xFFC09A5D);       // 古铜金
  static const Color darkWood = Color(0xFF3E2C1C);     // 暗褐

  // 字体名称（和 pubspec.yaml 里要一致）
  static const String fontTitle = 'MedievalSharp';
  static const String fontBody  = 'Merriweather';

  static ThemeData medieval() => ThemeData(
        scaffoldBackgroundColor: parchment,
        primaryColor: copper,
        fontFamily: fontBody,
        textTheme: TextTheme(
          headlineLarge: TextStyle(
            fontFamily: fontTitle,
            fontSize: 32,
            color: inkBrown,
          ),
          bodyLarge: TextStyle(color: inkBrown, fontSize: 16),
          bodyMedium: TextStyle(color: inkBrown, fontSize: 14),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: parchment,
          foregroundColor: inkBrown,
          elevation: 0,
        ),
      );
}
