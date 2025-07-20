import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/game_controller.dart';
import '../widgets/progress_panel.dart';
import '../constants/assets.dart';

class RolesOverviewPage extends ConsumerWidget {
  const RolesOverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameControllerProvider);

    return Scaffold(
      appBar: const ProgressPanel(),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: state.players.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
            final player = state.players[index];
            return Card(
              elevation: 1.5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(AppAssets.images.avatarPlaceholder),
                  child: Text(
                    player.name.characters.first.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(player.name),
                subtitle: Text('角色：${player.role.name}'),
                trailing: Text('#${index + 1}'),
              ),
            );
        },
      ),
    );
  }
}
