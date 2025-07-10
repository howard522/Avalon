import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/game_controller.dart';
import '../models/game_state.dart';

class MissionResultPage extends ConsumerWidget {
  const MissionResultPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameControllerProvider);
    final teamNames = state.proposedTeam
        .map((i) => state.players[i].name)
        .join(', ');

    return Scaffold(
      appBar: AppBar(title: const Text('任務結果')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('本回合隊伍：$teamNames'),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                ref.read(gameControllerProvider.notifier).recordMissionResult(true);
                Navigator.pop(context);
              },
              child: const Text('任務成功'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(gameControllerProvider.notifier).recordMissionResult(false);
                Navigator.pop(context);
              },
              child: const Text('任務失敗'),
            ),
            if (state.failedMissionCount > 0) ...[
              const SizedBox(height: 16),
              Text('連續失敗次數：${state.failedMissionCount}'),
            ],
          ],
        ),
      ),
    );
  }
}