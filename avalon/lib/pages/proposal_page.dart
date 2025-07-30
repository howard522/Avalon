import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/game_controller.dart';
import '../models/team_size_factory.dart';
import '../models/player.dart';
import '../widgets/round_token_bar.dart';
import '../widgets/medieval_button.dart';
import 'vote_page.dart';
import 'reminder_page.dart';

class ProposalPage extends ConsumerStatefulWidget {
  const ProposalPage({Key? key}) : super(key: key);

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

    // 每回合所需人數
    final teamSizes = List.generate(
      totalRounds,
      (i) => TeamSizeFactory.teamSize(players.length, i + 1),
    );
    final teamSizeThisRound = teamSizes[round - 1];

    // 計算要限制的寬度（左右各 12 padding）
    final boardWidth = MediaQuery.of(context).size.width - 24;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            width: boardWidth,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/textures/bulletin_board.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                // Header：卷軸標題 + TokenBar
                _RoundHeaderBar(
                  round: round,
                  needCount: teamSizeThisRound,
                  width: boardWidth,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
                  child: RoundTokenBar(
                    playerCount: players.length,
                    missionHistory: state.missionHistory,
                  ),
                ),

                // 玩家選擇 Grid（2×5）
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 4, // 讓木牌更寬扁
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      children: [
                        for (int i = 0; i < 10; i++)
                          if (i < players.length)
                            _PlayerTile(
                              player: players[i],
                              selected: _selected.contains(i),
                              onTap: () {
                                setState(() {
                                  if (_selected.contains(i)) {
                                    _selected.remove(i);
                                  } else if (_selected.length <
                                      teamSizeThisRound) {
                                    _selected.add(i);
                                  }
                                });
                              },
                            )
                          else
                            const SizedBox.shrink(),
                      ],
                    ),
                  ),
                ),

                // 動作按鈕：送審 / 清空 / 查看身份
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Column(
                    children: [
                      MedievalButton(
                        label:
                            '送審 (${_selected.length}/$teamSizeThisRound)',
                        enabled:
                            _selected.length == teamSizeThisRound,
                        onPressed: () {
                          if (_selected.length != teamSizeThisRound) return;
                          // ← 這裡改成正確的 provider 名稱
                          ref
                              .read(gameControllerProvider.notifier)
                              .proposeTeam(_selected);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const VotePage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      MedievalButton(
                        label: '清空',
                        enabled: _selected.isNotEmpty,
                        onPressed: () => setState(() => _selected.clear()),
                      ),
                      const SizedBox(height: 6),
                      MedievalButton(
                        label: '查看身份（防呆）',
                        enabled: true,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ReminderPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────
// Header：卷軸背景 + 第 X 回合｜需 N 人
// ───────────────────────────────────────────────────────────────
class _RoundHeaderBar extends StatelessWidget {
  final int round;
  final int needCount;
  final double width;

  const _RoundHeaderBar({
    required this.round,
    required this.needCount,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'assets/images/decor/banner_scroll_small.png',
            fit: BoxFit.contain,
            width: width,
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
// 單一玩家木牌
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
          image:
              DecorationImage(image: AssetImage(bg), fit: BoxFit.fill),
        ),
        alignment: Alignment.center,
        child: Text(
          player.name,
          style: const TextStyle(
            fontFamily: 'MedievalSharp',
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
