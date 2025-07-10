// lib/pages/quest_page.dart

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/game_controller.dart';
import '../models/game_state.dart';
import '../models/player.dart';
import '../models/role.dart';            // for Faction
import '../widgets/progress_panel.dart';
import 'proposal_page.dart';
import 'assassinate_page.dart';
import 'result_page.dart';

class QuestPage extends ConsumerStatefulWidget {
  const QuestPage({Key? key}) : super(key: key);

  @override
  ConsumerState<QuestPage> createState() => _QuestPageState();
}

class _QuestPageState extends ConsumerState<QuestPage> {
  bool showButtons = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameControllerProvider);
    final round = state.goodScore + state.evilScore + 1;
    final voteIndex = state.missionVotes.length;
    final teamSize = state.proposedTeam.length;
    final playerIndex = state.proposedTeam[voteIndex];
    final player = state.players[playerIndex];

    // 好人只能 Success，壞人可選 Success/Fail
    final isEvil = player.role.faction == Faction.evil;
    final buttons = isEvil ? ['Success', 'Fail'] : ['Success'];
    buttons.shuffle(Random());

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
                    final success = label == 'Success';
                    // 臨時票數，用於顯示
                    final tempVotes = List<bool>.from(state.missionVotes)
                      ..add(success);
                    final successCount = tempVotes.where((v) => v).length;
                    final failCount = tempVotes.length - successCount;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ElevatedButton(
                        onPressed: () {
                          // 提交投票
                          ref
                              .read(gameControllerProvider.notifier)
                              .submitMissionVote(success);
                          setState(() => showButtons = false);

                          // 只有當所有隊員都投完票時，顯示結果並導航
                          if (tempVotes.length == teamSize) {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text('第 $round 回合 結果'),
                                content: Text(
                                  '成功票：$successCount\n'
                                  '失敗票：$failCount\n\n'
                                  '當前得分：\n'
                                  '好人 ${state.goodScore + (successCount > failCount ? 1 : 0)}  vs  '
                                  '壞人 ${state.evilScore + (failCount >= successCount ? 1 : 0)}',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            ).then((_) {
                              final newPhase =
                                  ref.read(gameControllerProvider).phase;
                              if (newPhase == GamePhase.proposal) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const ProposalPage()),
                                );
                              } else if (newPhase ==
                                  GamePhase.assassinate) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          const AssassinatePage()),
                                );
                              } else if (newPhase == GamePhase.result) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const ResultPage()),
                                );
                              }
                            });
                          }
                        },
                        child: Text(label),
                      ),
                    );
                  }).toList(),
                )
              : Text(
                  '請將手機交給 ${player.name} 選擇任務結果',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
        ),
      ),
    );
  }
}
