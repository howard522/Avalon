// lib/main.dart（供確認，保持用 AppBackground 包住）
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'theme.dart';
import 'pages/home_page.dart';
import 'widgets/app_background.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const ProviderScope(child: AvalonApp()));
}

class AvalonApp extends StatelessWidget {
  const AvalonApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Avalon',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.medieval(),
      builder: (context, child) {
        if (child == null) return const SizedBox.shrink();
        return AppBackground(child: child);
      },
      home: const HomePage(),
    );
  }
}
