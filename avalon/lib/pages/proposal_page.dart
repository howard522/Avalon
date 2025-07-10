import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/game_controller.dart';
import '../models/game_state.dart';
import '../models/player.dart';
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
    const teamSize = 2;
    return Scaffold(
      appBar: AppBar(title: const Text('Team Proposal')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('第${state.leaderIndex + 1}位領隊: ${players[state.leaderIndex].name}'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: List.generate(players.length, (i) {
                final sel = _selected.contains(i);
                return ChoiceChip(
                  label: Text(players[i].name),
                  selected: sel,
                  onSelected: (v) => setState(() => v ? _selected.add(i) : _selected.remove(i)),
                );
              }),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _selected.length == teamSize
                  ? () {
                      ref.read(gameControllerProvider.notifier).proposeTeam(_selected);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const QuestPage()),
                      );
                    }
                  : null,
              child: const Text('送審'),
            ),
          ],
        ),
      ),
    );
  }
}