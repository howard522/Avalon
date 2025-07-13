// lib/pages/proposal_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/game_controller.dart';
import '../models/game_state.dart';
import '../models/player.dart';
import '../models/team_size_factory.dart';
import '../widgets/progress_panel.dart';
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
    final round = state.goodScore + state.evilScore + 1; // 1-based
    final totalRounds = 5; // Avalon 固定 5 回合任務
    final teamSizes = List.generate(
      totalRounds,
      (i) => TeamSizeFactory.teamSize(players.length, i + 1),
    );
    final teamSizeThisRound = teamSizes[round - 1];
    final teamSizeLimit = teamSizeThisRound;

    return Scaffold(
      appBar: const ProgressPanel(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // —— 新增區塊：顯示未來各回合隊伍人數 ——
            Text('回合隊伍規模', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                for (int i = 0; i < teamSizes.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Chip(
                      label: Text(
                        '${teamSizes[i]}',
                        style: TextStyle(
                          fontWeight:
                              (i + 1) == round
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                          fontSize: 16,
                        ),
                      ),
                      backgroundColor:
                          (i + 1) == round
                              ? Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.2)
                              : null,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            // —— 原有選人區塊 ——
            Text(
              '第 $round 回合 • 領隊：${players[state.leaderIndex].name} '
              '（需選 $teamSizeThisRound 人）',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: List.generate(players.length, (i) {
                final sel = _selected.contains(i);
                return ChoiceChip(
                  label: Text(players[i].name),
                  selected: sel,
                  onSelected:
                      (v) => setState(() {
                        if (v) {
                          if (_selected.length < teamSizeLimit)
                            _selected.add(i);
                        } else {
                          _selected.remove(i);
                        }
                      }),
                  selectedColor: Theme.of(
                    context,
                  ).colorScheme.primary.withOpacity(0.3),
                );
              }),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed:
                    _selected.length == teamSizeLimit
                        ? () {
                          ref
                              .read(gameControllerProvider.notifier)
                              .proposeTeam(_selected);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const VotePage()),
                          );
                        }
                        : null,
                child: Text(
                  '送審 (${_selected.length}／$teamSizeThisRound 人)',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
