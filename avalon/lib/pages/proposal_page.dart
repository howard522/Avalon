import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/game_controller.dart';
import '../models/team_size_factory.dart';
import '../models/player.dart';
import '../widgets/round_token_bar.dart';
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
    final leaderName = players[state.leaderIndex].name;
    const totalRounds = 5;

    // 每回合所需人數
    final teamSizes = List.generate(
      totalRounds,
      (i) => TeamSizeFactory.teamSize(players.length, i + 1),
    );
    final needCount = teamSizes[round - 1];

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/textures/wood_plank_full.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 1️⃣ 回合卷軸
              _RoundHeaderBar(round: round, needCount: needCount),
              const SizedBox(height: 8),

              // 2️⃣ 領隊卷軸
              _LeaderScrollBar(leaderName: leaderName),
              const SizedBox(height: 12),

              // 3️⃣ TokenBar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: RoundTokenBar(
                  playerCount: players.length,
                  missionHistory: state.missionHistory,
                ),
              ),

              // 4️⃣ 玩家選擇 Grid（2×5）
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 4,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    children: List.generate(10, (i) {
                      if (i < players.length) {
                        return _PlayerTile(
                          player: players[i],
                          selected: _selected.contains(i),
                          onTap: () {
                            setState(() {
                              if (_selected.contains(i)) {
                                _selected.remove(i);
                              } else if (_selected.length < needCount) {
                                _selected.add(i);
                              }
                            });
                          },
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),
                  ),
                ),
              ),

              // 5️⃣ 動作按鈕
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Column(
                  children: [
                    _PlaqueButton(
                      label: '送審 (${_selected.length}/$needCount)',
                      enabled: _selected.length == needCount,
                      onTap: () {
                        if (_selected.length != needCount) return;
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
                    _PlaqueButton(
                      label: '清空',
                      enabled: _selected.isNotEmpty,
                      onTap: () => setState(() => _selected.clear()),
                    ),
                    const SizedBox(height: 8),
                    _PlaqueButton(
                      label: '查看自己身份',
                      enabled: true,
                      onTap: () {
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
    );
  }
}

/// 回合卷軸：第 X 回合 ｜ 需 N 人
class _RoundHeaderBar extends StatelessWidget {
  final int round;
  final int needCount;
  const _RoundHeaderBar({
    required this.round,
    required this.needCount,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: double.infinity,
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

/// 領隊卷軸：領隊：XXX
class _LeaderScrollBar extends StatelessWidget {
  final String leaderName;
  const _LeaderScrollBar({required this.leaderName});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: double.infinity,
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
            '領隊：$leaderName',
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

/// 單一玩家木牌
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
    // 未選中用暗版，選中用亮版
    final image = AssetImage(
      selected
          ? 'assets/images/plaques/wood_plaque_light.png'
          : 'assets/images/plaques/wood_plaque_dark.png',
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: image, fit: BoxFit.fill),
        ),
        alignment: Alignment.center,
        child: Text(
          player.name,
          style: TextStyle(
            fontFamily: 'MedievalSharp',
            fontSize: 20,
            // 如果暗牌文字不明顯可以進一步調整：
            color: selected ? Colors.black87 : Colors.white70,
          ),
        ),
      ),
    );
  }
}

/// 通用木牌按鈕（與玩家木牌相同風格）
class _PlaqueButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback onTap;
  const _PlaqueButton({
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final image = AssetImage(
      enabled
          ? 'assets/images/plaques/wood_plaque_light.png'
          : 'assets/images/plaques/wood_plaque_dark.png',
    );

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Opacity(
        opacity: enabled ? 1 : 0.5,
        child: Container(
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(image: image, fit: BoxFit.fill),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'MedievalSharp',
              fontSize: 20,
              color: enabled ? Colors.black87 : Colors.white70,
            ),
          ),
        ),
      ),
    );
  }
}
