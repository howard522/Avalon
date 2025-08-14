// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/wood_plaque_button.dart';
import 'setup_page.dart';
import 'help_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      // 背景由 AppBackground 統一處理
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 靜態 Logo（移除動態縮放）
            Image.asset(
              'assets/images/icons/home_logo.png',
              width: 400,
              height: 400,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: 280,
              child: WoodPlaqueButton(
                label: '開始遊戲',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SetupPage()),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 280,
              child: WoodPlaqueButton(
                label: '遊戲說明',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HelpPage()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
