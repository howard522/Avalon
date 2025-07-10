import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/game_controller.dart';
import '../models/game_state.dart';
import 'quest_page.dart';

class VotePage extends ConsumerStatefulWidget {
  const VotePage({Key? key}) : super(key: key);

  @override
  ConsumerState<VotePage> createState() => _VotePageState();
}

class _VotePageState extends ConsumerState<VotePage> {
  bool _showButtons = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameControllerProvider);
    final idx = state.votes.length;
    final player = state.players[idx];

    return Scaffold(
      appBar: AppBar(title: const Text('Voting')),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (!_showButtons) {
            setState(() => _showButtons = true);
          }
        },
        child: Center(
          child: _showButtons
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        ref
                            .read(gameControllerProvider.notifier)
                            .castVote(true);
                        _advance(context, state);
                      },
                      child: const Text('Approve'),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        ref
                            .read(gameControllerProvider.notifier)
                            .castVote(false);
                        _advance(context, state);
                      },
                      child: const Text('Reject'),
                    ),
                  ],
                )
              : Text('請將手機交給 ${player.name} 投票'),
        ),
      ),
    );
  }

  void _advance(BuildContext context, GameState state) {
    setState(() => _showButtons = false);
    if (state.votes.length >= state.players.length) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const QuestPage()),
      );
    }
  }
}