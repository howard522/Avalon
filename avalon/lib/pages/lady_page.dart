// lib/pages/lady_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/game_controller.dart';
import '../models/game_state.dart';
import '../widgets/progress_panel.dart';
import '../widgets/wood_plaque_button.dart';
import 'proposal_page.dart';
import '../models/role.dart';

class LadyPage extends ConsumerWidget {
  const LadyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameControllerProvider);
    final controller = ref.read(gameControllerProvider.notifier);

    if (state.ladyTargetIndex == null) {
      final holderName = state.players[state.ladyHolderIndex].name;
      return Scaffold(
        appBar: const ProgressPanel(),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(
                '湖中女神持有者：$holderName\n\n請選擇一位玩家查看其真實陣營',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  children: state.players.asMap().entries.map((e) {
                    final idx = e.key;
                    final name = e.value.name;
                    if (idx == state.ladyHolderIndex) {
                      return const SizedBox.shrink();
                    }
                    return WoodPlaqueButton(
                      label: name,
                      onTap: () => controller.inspectLady(idx),
                      height: 54,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      final target = state.ladyTargetIndex!;
      final faction = state.players[target].role.faction == Faction.good ? '好人' : '壞人';
      return Scaffold(
        appBar: const ProgressPanel(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${state.players[target].name} 的陣營是：$faction',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: 260,
                  child: WoodPlaqueButton(
                    label: '繼續提名下一回合',
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const ProposalPage()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
