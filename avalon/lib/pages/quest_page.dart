import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/game_controller.dart';
import '../models/game_state.dart';
import 'proposal_page.dart';
import 'assassinate_page.dart';
import '../widgets/progress_panel.dart';

class QuestPage extends ConsumerStatefulWidget {
  const QuestPage({Key? key}) : super(key: key);
  @override
  ConsumerState<QuestPage> createState() => _QuestPageState();
}

class _QuestPageState extends ConsumerState<QuestPage> {
  bool showButtons = false;
  late List<String> buttons;

  @override
  void initState() {
    super.initState();
    buttons = ['Success', 'Fail']..shuffle(Random());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameControllerProvider);
    final idx = state.missionVotes.length;
    final pi = state.proposedTeam[idx];
    final name = state.players[pi].name;

    return Scaffold(
      appBar: const ProgressPanel(),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => setState(() => showButtons = true),
        child: Center(
          child: showButtons
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: buttons.map((label) {
                    final ok = label == 'Success';
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ElevatedButton(
                        onPressed: () {
                          ref.read(gameControllerProvider.notifier).submitMissionVote(ok);
                          setState(() {
                            showButtons = false;
                            buttons = ['Success', 'Fail']..shuffle(Random());
                          });
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            final phase = ref.read(gameControllerProvider).phase;
                            if (phase == GamePhase.proposal) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => const ProposalPage()),
                              );
                            } else if (phase == GamePhase.assassinate) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => const AssassinatePage()),
                              );
                            }
                          });
                        },
                        child: Text(label),
                      ),
                    );
                  }).toList(),
                )
              : Text('請將手機交給 $name 選擇任務結果'),
        ),
      ),
    );
  }
}