import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/game_controller.dart';
import '../models/role_factory.dart';
import 'reveal_page.dart';

class SetupPage extends ConsumerStatefulWidget {
  const SetupPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends ConsumerState<SetupPage> {
  final _nameCtrl = TextEditingController();
  bool _ladyEnabled = true; // ← 預設開啟

  @override
  Widget build(BuildContext context) {
    final players = ref.watch(gameControllerProvider.select((s) => s.players));

    return Scaffold(
      appBar: AppBar(
        title: const Text('玩家設定'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ───────────────────── 新增玩家輸入 ─────────────────────
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: '玩家暱稱',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _addPlayer(),
            ),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _addPlayer, child: const Text('加入玩家')),
            const SizedBox(height: 20),

            // ───────────────────── 玩家列表 ─────────────────────
            Expanded(
              child: ListView.builder(
                itemCount: players.length,
                itemBuilder: (_, i) => ListTile(
                  leading: Text('#${i + 1}'),
                  title: Text(players[i].name),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () =>
                        ref.read(gameControllerProvider.notifier).removePlayer(i),
                  ),
                ),
              ),
            ),

            // ───────────────────── Lady 開關 ─────────────────────
            SwitchListTile(
              value: _ladyEnabled,
              onChanged: (v) => setState(() => _ladyEnabled = v),
              title: const Text('啟用湖中女神（建議 9-10 人開啟）'),
            ),
            const SizedBox(height: 12),

            // ───────────────────── 開始遊戲 ─────────────────────
            FilledButton(
              onPressed: players.length >= 5 ? _startGame : null,
              child: const Text('開始發牌'),
            ),
          ],
        ),
      ),
    );
  }

  void _addPlayer() {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;
    ref.read(gameControllerProvider.notifier).addPlayer(name);
    _nameCtrl.clear();
  }

  void _startGame() {
    final controller = ref.read(gameControllerProvider.notifier);
    controller.setLadyEnabled(_ladyEnabled);

    final players = ref.read(gameControllerProvider).players;
    final roles = RoleFactory.rolesForCount(players.length)..shuffle();
    controller.assignRoles(roles);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const RevealPage()),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }
}
