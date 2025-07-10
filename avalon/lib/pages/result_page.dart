import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/game_controller.dart';
import '../models/game_state.dart';
import 'setup_page.dart';
import 'help_page.dart';

class ResultPage extends ConsumerWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameControllerProvider);
    // 判定勝利方
    final winner = state.phase == GamePhase.result
        ? (state.goodScore > state.evilScore ? '好人' : '壞人')
        : (state.phase == GamePhase.assassinate && state.isAssassinationSuccess)
            ? '壞人' : '好人';

    return Scaffold(
      appBar: AppBar(title: const Text('遊戲結算')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('勝利方：$winner', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 16),
            Text('任務勝利：${state.goodScore}，失敗：${state.evilScore}', style: Theme.of(context).textTheme.titleMedium),
            if (state.phase == GamePhase.assassinate) ...[
              const SizedBox(height: 12),
              Text(
                state.isAssassinationSuccess
                  ? '刺殺成功：壞人勝利'
                  : '刺殺失敗：好人勝利',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                ref.read(gameControllerProvider.notifier).reset();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const SetupPage()),
                  (route) => false,
                );
              },
              child: const Text('再來一局'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HelpPage()),
                );
              },
              child: const Text('遊戲說明'),
            ),
          ],
        ),
      ),
    );
  }
}