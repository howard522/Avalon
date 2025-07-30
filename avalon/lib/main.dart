import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'theme.dart';
import 'pages/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // 隱藏系統 UI（狀態列、底部導航列）
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
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
