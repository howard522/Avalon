import 'package:avalon/pages/test_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const ProviderScope(child: AvalonApp()));
}

class AvalonApp extends StatelessWidget {
  const AvalonApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Avalon',
      theme: AppTheme.medieval(),
      home: const HomePage(),
    );
  }
}