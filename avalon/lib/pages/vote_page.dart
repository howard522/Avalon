import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/game_controller.dart';
import '../models/game_state.dart';
import '../widgets/progress_panel.dart';
import 'proposal_page.dart';
import 'quest_page.dart';
import 'result_page.dart';

class VotePage extends ConsumerWidget {
  const VotePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(gameControllerProvider.notifier);

    return Scaffold(
      appBar: const ProgressPanel(),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '數到「三」一起投票！\n\n'
              '👍 表示同意此隊伍\n'
              '👎 表示拒絕此隊伍\n\n'
              '主持人倒數：3…2…1…',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.thumb_up),
                  label: const Text('同意'),
                  onPressed: () {
                    controller.voteTeam(true);
                    _navigateNext(context, ref);
                  },
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.thumb_down),
                  label: const Text('拒絕'),
                  onPressed: () {
                    controller.voteTeam(false);
                    _navigateNext(context, ref);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _navigateNext(BuildContext context, WidgetRef ref) {
    final phase = ref.read(gameControllerProvider).phase;
    Widget nextPage;
    switch (phase) {
      case GamePhase.proposal:
        nextPage = const ProposalPage();
        break;
      case GamePhase.quest:
        nextPage = const QuestPage();
        break;
      case GamePhase.result:
        nextPage = const ResultPage();
        break;
      default:
        nextPage = const ProposalPage();
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => nextPage),
    );
  }
}
