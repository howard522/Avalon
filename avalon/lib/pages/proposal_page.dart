// lib/pages/proposal_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/game_controller.dart';
import '../models/game_state.dart';
import '../models/player.dart';
import '../models/team_size_factory.dart';
import '../widgets/progress_panel.dart';
import 'quest_page.dart';

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
    final teamSize = TeamSizeFactory.teamSize(players.length, round);

    return Scaffold(
      appBar: const ProgressPanel(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('第 $round 回合 • 領隊：${players[state.leaderIndex].name}'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: List.generate(players.length, (i) {
                final sel = _selected.contains(i);
                return ChoiceChip(
                  label: Text(players[i].name),
                  selected: sel,
                  onSelected: (v) => setState(() {
                    if (v) _selected.add(i);
                    else _selected.remove(i);
                  }),
                );
              }),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _selected.length == teamSize
                  ? () {
                      ref
                          .read(gameControllerProvider.notifier)
                          .proposeTeam(_selected);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const QuestPage()),
                      );
                    }
                  : null,
              child: Text('送審 ($teamSize 人)'),
            ),
          ],
        ),
      ),
    );
  }
}
