import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/game_controller.dart';
import '../models/team_size_factory.dart';
import '../pages/reminder_page.dart';
import 'vote_page.dart';

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

    final teamSizes = List.generate(
      totalRounds,
      (i) => TeamSizeFactory.teamSize(players.length, i + 1),
    );
    final teamSizeThisRound = teamSizes[round - 1];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeaderBar(
                round: round,
                leaderName: players[state.leaderIndex].name,
                goodScore: state.goodScore,
                evilScore: state.evilScore,
                onReminderTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ReminderPage()),
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildRoundScale(
                context: context,
                teamSizes: teamSizes,
                currentRound: round,
                missionHistory: state.missionHistory,
              ),
              const SizedBox(height: 20),
              Text(
                '選擇本回合隊伍（需 ${teamSizeThisRound} 人）',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(players.length, (i) {
                      final sel = _selected.contains(i);
                      return FilterChip(
                        label: Text(players[i].name),
                        selected: sel,
                        onSelected: (v) {
                          setState(() {
                            if (v) {
                              if (_selected.length < teamSizeThisRound) {
                                _selected.add(i);
                              }
                            } else {
                              _selected.remove(i);
                            }
                          });
                        },
                        selectedColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(.25),
                        showCheckmark: false,
                        avatar: CircleAvatar(
                          radius: 10,
                          backgroundColor: sel
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey[400],
                          child: Text(
                            players[i].name.characters.first.toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              color: sel ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _selected.length == teamSizeThisRound
                          ? () {
                              ref
                                  .read(gameControllerProvider.notifier)
                                  .proposeTeam(_selected);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const VotePage(),
                                ),
                              );
                            }
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Text(
                          '送審 (${_selected.length}/$teamSizeThisRound)',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton.filledTonal(
                    tooltip: '清除',
                    onPressed: _selected.isEmpty
                        ? null
                        : () => setState(() => _selected.clear()),
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ReminderPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.visibility),
                  label: const Text('查看身份（防呆）'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoundScale({
    required BuildContext context,
    required List<int> teamSizes,
    required int currentRound,
    required List<bool> missionHistory,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('回合隊伍規模 / 結果',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: List.generate(teamSizes.length, (i) {
            final roundNumber = i + 1;
            Color border = Colors.grey[400]!;
            Color? fill;
            Widget? resultIcon;

            if (i < missionHistory.length) {
              final isSuccess = missionHistory[i];
              fill = isSuccess ? Colors.green[100] : Colors.red[100];
              resultIcon = Icon(
                isSuccess ? Icons.check : Icons.close,
                size: 18,
                color: isSuccess ? Colors.green[700] : Colors.red[700],
              );
            } else if (roundNumber == currentRound) {
              fill = Colors.blue[50];
            }

            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding:
                  const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              decoration: BoxDecoration(
                color: fill,
                border: Border.all(color: border),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$roundNumber: ${teamSizes[i]}人',
                    style: const TextStyle(fontSize: 14),
                  ),
                  if (resultIcon != null) ...[
                    const SizedBox(width: 4),
                    resultIcon,
                  ],
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _HeaderBar extends StatelessWidget {
  final int round;
  final String leaderName;
  final int goodScore;
  final int evilScore;
  final VoidCallback onReminderTap;

  const _HeaderBar({
    Key? key,
    required this.round,
    required this.leaderName,
    required this.goodScore,
    required this.evilScore,
    required this.onReminderTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 左側資訊
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '第 $round 回合',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  '領隊：$leaderName',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _scoreChip(
                      label: '好人',
                      value: goodScore,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 6),
                    _scoreChip(
                      label: '壞人',
                      value: evilScore,
                      color: Colors.red,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                tooltip: '查看身份',
                onPressed: onReminderTap,
                icon: const Icon(Icons.visibility),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _scoreChip({
    required String label,
    required int value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 6,
            backgroundColor: color,
          ),
          const SizedBox(width: 4),
          Text(
            '$label $value',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _darken(color),
            ),
          ),
        ],
      ),
    );
  }

  Color _darken(Color c, [double amount = .22]) {
    final hsl = HSLColor.fromColor(c);
    final l = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(l).toColor();
  }
}
