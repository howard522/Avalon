import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/game_controller.dart';
import '../widgets/progress_panel.dart';

/// 所有玩家角色一覽頁面
class RolesOverviewPage extends ConsumerWidget {
  const RolesOverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameControllerProvider);

    return Scaffold(
      appBar: const ProgressPanel(),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.players.length,
        itemBuilder: (context, index) {
          final player = state.players[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                child: Text('${index + 1}'),
              ),
              title: Text(player.name),
              subtitle: Text('角色：${player.role.name}'),
            ),
          );
        },
      ),
    );
  }
}