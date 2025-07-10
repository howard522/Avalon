import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/game_controller.dart';
import '../models/role.dart';
import 'reveal_page.dart';
import '../widgets/progress_panel.dart';

class SetupPage extends ConsumerStatefulWidget {
  const SetupPage({super.key});
  @override
  ConsumerState<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends ConsumerState<SetupPage> {
  final _nameCtrl = TextEditingController();

  void _addPlayer() {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;
    ref.read(gameControllerProvider.notifier).addPlayer(name);
    _nameCtrl.clear();
  }

  void _startGame() {
    final roles = <Role>[
      Role.merlin(),
      Role.percival(),
      Role.loyalServant(),
      Role.assassin(),
      Role.morgana(),
    ]..shuffle();
    ref.read(gameControllerProvider.notifier).assignRoles(roles);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RevealPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final players = ref.watch(gameControllerProvider.select((s) => s.players));
    return Scaffold(
      appBar: const ProgressPanel(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: '玩家暱稱'),
              onSubmitted: (_) => _addPlayer(),
            ),
            ElevatedButton(onPressed: _addPlayer, child: const Text('加入玩家')),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: players.length,
                itemBuilder: (_, i) => ListTile(
                  leading: Text('#${i + 1}'),
                  title: Text(players[i].name),
                ),
              ),
            ),
            FilledButton(
              onPressed: players.length >= 5 ? _startGame : null,
              child: const Text('開始發牌'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }
}