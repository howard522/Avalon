// lib/pages/quest_page.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/game_controller.dart';
import '../models/game_state.dart';
import '../models/player.dart';
import '../models/role.dart';              // for Faction
import '../widgets/progress_panel.dart';
import 'proposal_page.dart';
import 'lady_page.dart';
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
    final controller = ref.read(gameControllerProvider.notifier);

    final round = state.goodScore + state.evilScore + 1;
    final voteIndex = state.missionVotes.length;
    final teamSize = state.proposedTeam.length;
    final playerIndex = state.proposedTeam[voteIndex];
    final player = state.players[playerIndex];

    // 無論好壞皆可見 Success / Fail
    final buttons = ['Success', 'Fail']..shuffle(Random());

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
                    final isEvil = player.role.faction == Faction.evil;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ElevatedButton(
                        onPressed: () {
                          // 好人按 Fail，自動改為 Success 並提示
                          if (!isEvil && !success) {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('提醒'),
                                content: const Text(
                                  '你是好人角色，不能投 Fail！\n'
                                  '系統將自動視為 Success。',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _submitVote(
                                        controller: controller,
                                        context: context,
                                        ref: ref,
                                        success: true,
                                        state: state,
                                        teamSize: teamSize,
                                      );
                                    },
                                    child: const Text('我知道了'),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            // 刺客或好人按 Success / 壞人均正常送出
                            _submitVote(
                              controller: controller,
                              context: context,
                              ref: ref,
                              success: success,
                              state: state,
                              teamSize: teamSize,
                            );
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

  void _submitVote({
    required GameController controller,
    required BuildContext context,
    required WidgetRef ref,
    required bool success,
    required GameState state,
    required int teamSize,
  }) {
    controller.submitMissionVote(success);
    setState(() => showButtons = false);

    final tempVotes = List<bool>.from(state.missionVotes)..add(success);
    if (tempVotes.length == teamSize) {
      final successCount = tempVotes.where((v) => v).length;
      final failCount = tempVotes.length - successCount;

      // 顯示本回合結果
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('第 ${state.goodScore + state.evilScore + 1} 回合 結果'),
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
        final newPhase = ref.read(gameControllerProvider).phase;
        Widget nextPage;
        switch (newPhase) {
          case GamePhase.proposal:
            nextPage = const ProposalPage();
            break;
          case GamePhase.lady:
            nextPage = const LadyPage();
            break;
          case GamePhase.assassinate:
            nextPage = const AssassinatePage();
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
      });
    }
  }
}
