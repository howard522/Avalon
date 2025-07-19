// lib/pages/quest_page.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/game_controller.dart';
import '../models/game_state.dart';
import '../models/role.dart'; // 判斷 Faction
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
  bool locked = false;            // 防止連點
  bool waitingNextPlayer = false; // 顯示「交給下一位」提示
  int shuffleSeed = 0;            // 用於重新隨機兩張卡順序

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameControllerProvider);
    final controller = ref.read(gameControllerProvider.notifier);

    final voteIndex = state.missionVotes.length;
    final teamSize = state.proposedTeam.length;
    final playerIndex = state.proposedTeam[voteIndex];
    final player = state.players[playerIndex];
    final isEvil = player.role.faction == Faction.evil;

    return Scaffold(
      appBar: const ProgressPanel(),
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: waitingNextPlayer
              ? _buildNextPlayerPrompt(state)
              : _buildChoiceArea(
                  context: context,
                  player: player,
                  isEvil: isEvil,
                  onSelect: (success) => _handleSelect(
                    controller: controller,
                    success: success,
                    context: context,
                    state: state,
                    teamSize: teamSize,
                  ),
                ),
        ),
      ),
    );
  }

  /// 顯示兩張卡牌（成功 / 失敗）與標題
  Widget _buildChoiceArea({
    required BuildContext context,
    required player,
    required bool isEvil,
    required void Function(bool success) onSelect,
  }) {
    final cards = <_VoteCardData>[
      _VoteCardData(
        label: '成功',
        successValue: true,
        imagePath: 'assets/images/card_success.png',
      ),
      _VoteCardData(
        label: '失敗',
        successValue: false,
        imagePath: 'assets/images/card_fail.png',
      ),
    ]..shuffle(Random(shuffleSeed));

    return Column(
      key: ValueKey('choiceArea_$shuffleSeed'),
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '請將手機交給：${player.name}\n選擇此回合的任務結果',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 28),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: cards.map((c) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _VoteCard(
                label: c.label,
                imagePath: c.imagePath,
                disabled: locked,
                onTap: () async {
                  if (locked) return;
                  if (!isEvil && !c.successValue) {
                    await _showGoodCannotFailDialog(context);
                    onSelect(true);
                  } else {
                    onSelect(c.successValue);
                  }
                },
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// 投完還沒結束時提示交給下一位（顯示下一位玩家名稱）
  Widget _buildNextPlayerPrompt(GameState state) {
    final voteIndex = state.missionVotes.length; // 已投出票數（包含剛剛那票）
    final teamSize = state.proposedTeam.length;
    final remaining = teamSize - voteIndex;
    final bool hasNext = voteIndex < teamSize;

    String nextPlayerName = '';
    if (hasNext) {
      final nextPlayerGlobalIndex = state.proposedTeam[voteIndex];
      nextPlayerName = state.players[nextPlayerGlobalIndex].name;
    }

    final nextIsLast = remaining == 1;

    return Column(
      key: const ValueKey('nextPlayerPrompt'),
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          hasNext ? '請將手機交給：$nextPlayerName' : '處理中…',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        if (hasNext)
          Text(
            nextIsLast
                ? '下一位是本回合最後一位投票者'
                : '尚餘 $remaining 位成員未投票',
            style: const TextStyle(fontSize: 16, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        const SizedBox(height: 28),
        ElevatedButton(
          onPressed: () {
            setState(() {
              waitingNextPlayer = false;
              shuffleSeed = DateTime.now().millisecondsSinceEpoch;
            });
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Text('準備好了'),
          ),
        ),
      ],
    );
  }

  Future<void> _showGoodCannotFailDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('提醒'),
        content: const Text('你是好人角色，不能讓任務失敗。\n已自動記錄為「成功」。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('確認'),
          ),
        ],
      ),
    );
  }

  void _handleSelect({
    required GameController controller,
    required bool success,
    required BuildContext context,
    required GameState state,
    required int teamSize,
  }) {
    setState(() => locked = true);

    controller.submitMissionVote(success);

    final tempVotes = List<bool>.from(state.missionVotes)..add(success);
    final currentCount = tempVotes.length;

    if (currentCount == teamSize) {
      final successCount = tempVotes.where((v) => v).length;
      final failCount = currentCount - successCount;

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('結果 (第 ${state.goodScore + state.evilScore + 1} 回合)'),
          content: Text(
            '成功：$successCount\n失敗：$failCount\n\n'
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
      ).then((_) => _navigateNext(context));
    } else {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!mounted) return;
        setState(() {
          locked = false;
          waitingNextPlayer = true;
        });
      });
    }
  }

  void _navigateNext(BuildContext context) {
    final phase = ref.read(gameControllerProvider).phase;
    Widget nextPage;
    switch (phase) {
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
  }
}

class _VoteCardData {
  final String label;
  final bool successValue;
  final String imagePath;
  _VoteCardData({
    required this.label,
    required this.successValue,
    required this.imagePath,
  });
}

class _VoteCard extends StatelessWidget {
  final String label;
  final String imagePath;
  final VoidCallback? onTap;
  final bool disabled;

  const _VoteCard({
    Key? key,
    required this.label,
    required this.imagePath,
    this.onTap,
    this.disabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final card = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: disabled ? 0.55 : 1.0,
          child: Container(
            width: 140,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[400]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );

    if (disabled) return card;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        scale: 1.0,
        child: card,
      ),
    );
  }
}
