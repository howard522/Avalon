import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/game_controller.dart';
import '../models/game_state.dart';
import '../widgets/progress_panel.dart';
import 'setup_page.dart';

class ResultPage extends ConsumerWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameControllerProvider);
    final notifier = ref.read(gameControllerProvider.notifier);

    final bool hasAssassinated = state.assassinationTargetIndex != null;
    final bool assassinSucceeded = state.isAssassinationSuccess;
    final String winner = hasAssassinated
        ? (assassinSucceeded ? '壞人' : '好人')
        : (state.goodScore > state.evilScore ? '好人' : '壞人');

    return Scaffold(
      appBar: const ProgressPanel(),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('勝利方：$winner', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 16),
            if (hasAssassinated) ...[
              Text(
                assassinSucceeded
                  ? '刺客成功刺殺梅林：壞人勝利！'
                  : '刺客失敗：好人勝利！',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ] else ...[
              Text(
                '任務成功：${state.goodScore} 次 ；失敗：${state.evilScore} 次',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    notifier.resetKeepPlayers();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const SetupPage()),
                      (route) => false,
                    );
                  },
                  child: const Text('再來一局'),
                ),
                ElevatedButton(
                  onPressed: () {
                    notifier.reset();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const SetupPage()),
                      (route) => false,
                    );
                  },
                  child: const Text('重新開始'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '「再來一局」保留玩家名單，重新分配角色；\n'
              '「重新開始」清空所有玩家並回到初始',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}