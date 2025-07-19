// lib/pages/proposal_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/game_controller.dart';
import '../models/game_state.dart';
import '../models/team_size_factory.dart';
import '../pages/reminder_page.dart';
import '../widgets/progress_panel.dart';
import 'vote_page.dart'; // ← 使用 VotePage

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
    final pastRounds = state.goodScore + state.evilScore;

    return Scaffold(
      appBar: const ProgressPanel(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRoundScale(
                context: context,
                teamSizes: teamSizes,
                currentRound: round,
                pastRounds: pastRounds,
                goodScore: state.goodScore,
                evilScore: state.evilScore,
              ),
              const SizedBox(height: 24),
              Text(
                '第 $round 回合 • 領隊：${players[state.leaderIndex].name} （需選 $teamSizeThisRound 人）',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(players.length, (i) {
                  final sel = _selected.contains(i);
                  return ChoiceChip(
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
                        .withOpacity(0.25),
                  );
                }),
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _selected.length == teamSizeThisRound
                      ? () {
                          ref
                              .read(gameControllerProvider.notifier)
                              .proposeTeam(_selected);
                          // ★ 修正：送審後跳轉
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const VotePage(),
                            ),
                          );
                        }
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                    child: Text(
                      '送審 (${_selected.length}/$teamSizeThisRound)',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ReminderPage(),
                      ),
                    );
                  },
                  child: const Text('查看身份（防呆）'),
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
    required int pastRounds,
    required int goodScore,
    required int evilScore,
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

            if (i < pastRounds) {
              final isSuccess = i < goodScore;
              fill = isSuccess ? Colors.green[100] : Colors.red[100];
              resultIcon = Icon(
                isSuccess ? Icons.check : Icons.close,
                size: 18,
                color: isSuccess ? Colors.green[700] : Colors.red[700],
              );
            } else if (roundNumber == currentRound) {
              fill = Colors.blue[50];
            }

            return Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              decoration: BoxDecoration(
                color: fill,
                border: Border.all(color: border),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('$roundNumber: ${teamSizes[i]}人',
                      style: const TextStyle(fontSize: 14)),
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
