import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/game_controller.dart';
import '../models/game_state.dart';
import '../models/player.dart';
import '../models/role.dart';  // 新增 import
import 'result_page.dart';

class AssassinatePage extends ConsumerWidget {
  const AssassinatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameControllerProvider);
    // 找出 Assassin 角色的玩家索引
    final assassinIndex = state.players.indexWhere((p) => p.role is Assassin);
    final assassinName = assassinIndex >= 0
        ? state.players[assassinIndex].name
        : 'Unknown';

    return Scaffold(
      appBar: AppBar(title: const Text('刺殺階段')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('刺客: $assassinName', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            const Text('請選擇你要刺殺的目標：'),
            const SizedBox(height: 16),
            ...state.players.asMap().entries.map((entry) {
              final idx = entry.key;
              final name = entry.value.name;
              // 刺客自己不能選自己
              if (idx == assassinIndex) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(gameControllerProvider.notifier).assassinate(idx);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const ResultPage()),
                    );
                  },
                  child: Text(name),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}