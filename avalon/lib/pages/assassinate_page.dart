// lib/pages/assassinate_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/game_controller.dart';
import '../models/role.dart';
import '../widgets/wood_plaque_button.dart';
import 'result_page.dart';

class AssassinatePage extends ConsumerWidget {
  const AssassinatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameControllerProvider);
    final assassinIndex = state.players.indexWhere((p) => p.role is Assassin);
    final assassinName = assassinIndex >= 0 ? state.players[assassinIndex].name : 'Unknown';

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
            Expanded(
              child: ListView(
                children: state.players.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final name = entry.value.name;
                  if (idx == assassinIndex) return const SizedBox.shrink();
                  return WoodPlaqueButton(
                    label: name,
                    onTap: () {
                      ref.read(gameControllerProvider.notifier).assassinate(idx);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const ResultPage()),
                      );
                    },
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
  }
}
