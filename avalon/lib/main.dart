import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'controllers/theme_controller.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const ProviderScope(child: AvalonApp()));
}

class AvalonApp extends ConsumerWidget {
  const AvalonApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp(
      title: 'Avalon',
      themeMode: themeMode,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,        // 白底
        primaryColor: Colors.grey[800],               // 主要深灰
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[800],
            foregroundColor: Colors.white,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.grey[800],
            side: BorderSide(color: Colors.grey[400]!),
          ),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          titleMedium: TextStyle(
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
      ),
      darkTheme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const HomePage(),
    );
  }
}
