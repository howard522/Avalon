import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/game_controller.dart';
import '../models/team_size_factory.dart';
import '../widgets/round_token_bar.dart';
import '../widgets/medieval_button.dart';
import '../models/player.dart';

class ProposalPage extends ConsumerStatefulWidget {
  const ProposalPage({super.key});
  @override
  ConsumerState<ProposalPage> createState() => _ProposalPageState();
}

class _ProposalPageState extends ConsumerState<ProposalPage> {
  final List<int> _selected = [];

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameControllerProvider);
    final players = state.players;
    final round = state.goodScore + state.evilScore + 1;
    const totalRounds = 5;

    // 5 回合所需人數
    final teamSizes =
        List.generate(totalRounds, (i) => TeamSizeFactory.teamSize(players.length, i + 1));
    final teamSizeThisRound = teamSizes[round - 1];

    return Scaffold(
      body: SafeArea(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/textures/bulletin_board.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              // ────────────── Header（卷軸 + Token）──────────────
              _RoundHeaderBar(round: round, needCount: teamSizeThisRound),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
                child: RoundTokenBar(
                  playerCount: players.length,
                  missionHistory: state.missionHistory,
                ),
              ),

              // ────────────── 玩家選擇 Grid ──────────────
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 3.5,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    children: [
                      for (int i = 0; i < 10; i++)
                        i < players.length
                            ? _PlayerTile(
                                player: players[i],
                                selected: _selected.contains(i),
                                onTap: () {
                                  setState(() {
                                    if (_selected.contains(i)) {
                                      _selected.remove(i);
                                    } else if (_selected.length < teamSizeThisRound) {
                                      _selected.add(i);
                                    }
                                  });
                                },
                              )
                            : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ),

              // ────────────── 動作按鈕 ──────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Column(
                  children: [
                    MedievalButton(
                      label: '送審 (${_selected.length}/$teamSizeThisRound)',
                      enabled: _selected.length == teamSizeThisRound,
                      onPressed: () {
                        if (_selected.length != teamSizeThisRound) return;
                        ref.read(gameControllerProvider.notifier).proposeTeam(_selected);
                        Navigator.pushNamed(context, '/vote');
                      },
                    ),
                    const SizedBox(height: 8),
                    MedievalButton(
                      label: '清空',
                      enabled: _selected.isNotEmpty,
                      onPressed: () => setState(() => _selected.clear()),
                    ),
                    const SizedBox(height: 6),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/reminder'); // 你的 ReminderPage 路由
                      },
                      icon: const Icon(Icons.visibility),
                      label: const Text('查看身份（防呆）'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────
// Header：卷軸背景 + 文字
// ───────────────────────────────────────────────────────────────
class _RoundHeaderBar extends StatelessWidget {
  final int round;
  final int needCount;
  const _RoundHeaderBar({required this.round, required this.needCount});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'assets/images/decor/banner_scroll_small.png',
            fit: BoxFit.contain,
            width: double.infinity,
            height: double.infinity,
          ),
          Text(
            '第 $round 回合 ｜ 需 $needCount 人',
            style: const TextStyle(
              fontFamily: 'MedievalSharp',
              fontSize: 24,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────
// Player 木牌
// ───────────────────────────────────────────────────────────────
class _PlayerTile extends StatelessWidget {
  final Player player;
  final bool selected;
  final VoidCallback onTap;
  const _PlayerTile({
    required this.player,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected
        ? 'assets/images/plaques/wood_plaque_dark.png'
        : 'assets/images/plaques/wood_plaque_light.png';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(bg), fit: BoxFit.fill),
        ),
        alignment: Alignment.center,
        child: Text(
          player.name,
          style: const TextStyle(
            fontFamily: 'MedievalSharp',
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
