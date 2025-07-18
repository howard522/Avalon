import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'setup_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avalon'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo / 示意圖
            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.shield,
                size: 48,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),

            // 開始遊戲 ← 用自訂圖示＋文字
            SizedBox(
              width: 200,
              child: ElevatedButton.icon(
                icon: ImageIcon(
                  AssetImage('assets/images/home_icon_start.png'),
                  size: 24,
                ),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('開始遊戲', style: TextStyle(fontSize: 18)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SetupPage()),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // 遊戲說明 ← 用自訂圖示＋文字
            SizedBox(
              width: 200,
              child: OutlinedButton.icon(
                icon: ImageIcon(
                  AssetImage('assets/images/home_icon_rules.png'),
                  size: 24,
                ),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('遊戲說明', style: TextStyle(fontSize: 18)),
                ),
                onPressed: () {
                  // TODO: 顯示遊戲規則
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
