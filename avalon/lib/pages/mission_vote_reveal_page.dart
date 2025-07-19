import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/game_controller.dart';
import '../models/game_state.dart';
import 'proposal_page.dart';
import 'lady_page.dart';
import 'assassinate_page.dart';
import 'result_page.dart';

class MissionVoteRevealPage extends ConsumerStatefulWidget {
  const MissionVoteRevealPage({Key? key}) : super(key: key);

  @override
  ConsumerState<MissionVoteRevealPage> createState() => _MissionVoteRevealPageState();
}

class _MissionVoteRevealPageState extends ConsumerState<MissionVoteRevealPage> {
  int revealedCount = 0;
  late int totalVotes;
  late int successVotes;
  late int failVotes;

  @override
  void initState() {
    super.initState();
    final state = ref.read(gameControllerProvider);
    // 我們在進入此頁前已把這回合的結果（成功/失敗計入分數），
    // 但要顯示票數，需要在 push 之前傳或暫存。
    // 為簡化：使用 ModalRoute arguments（已在 QuestPage push 時傳入）
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is _MissionRevealArgs) {
      totalVotes = args.teamSize;
      successVotes = args.successCount;
      failVotes = args.failCount;
    } else {
      totalVotes = 0;
      successVotes = 0;
      failVotes = 0;
    }

    final tokens = _buildOrderedTokens(
      successVotes: successVotes,
      failVotes: failVotes,
      total: totalVotes,
    );

    final revealed = tokens.take(revealedCount).toList();
    final hidden = tokens.skip(revealedCount).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('任務投票揭示'),
        centerTitle: true,
        elevation: 0,
        actions: [
          // 回合資訊顯示簡化
          _ScoreBadge(),
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (revealedCount < totalVotes) {
            setState(() => revealedCount++);
          } else {
            _goNextPhase(context);
          }
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                revealedCount < totalVotes
                    ? '點擊揭示下一枚指示物 (${revealedCount + 1}/$totalVotes)'
                    : '點擊前往下一階段',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 24),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: [
                  ...revealed.map((t) => _Token(imagePath: t)),
                  for (int i = 0; i < hidden; i++)
                    const _Token(imagePath: 'assets/images/token_hidden.png'),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                '本回合結果：成功 $successVotes ；失敗 $failVotes',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                '（成功指示物會先全部揭示，接著再揭示失敗）\n'
                '此順序不對應真實玩家順序，避免資訊外洩。',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.black54),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<String> _buildOrderedTokens({
    required int successVotes,
    required int failVotes,
    required int total,
  }) {
    final list = <String>[];
    for (int i = 0; i < successVotes; i++) {
      list.add('assets/images/token_success.png');
    }
    for (int i = 0; i < failVotes; i++) {
      list.add('assets/images/token_fail.png');
    }
    // 容錯：若 success+fail < total（理論不會發生）
    while (list.length < total) {
      list.add('assets/images/token_hidden.png');
    }
    return list;
  }

  void _goNextPhase(BuildContext context) {
    final phase = ref.read(gameControllerProvider).phase;
    Widget next;
    switch (phase) {
      case GamePhase.proposal:
        next = const ProposalPage();
        break;
      case GamePhase.lady:
        next = const LadyPage();
        break;
      case GamePhase.assassinate:
        next = const AssassinatePage();
        break;
      case GamePhase.result:
        next = const ResultPage();
        break;
      default:
        next = const ProposalPage();
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => next),
    );
  }
}

class _Token extends StatelessWidget {
  final String imagePath;
  const _Token({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      width: 64,
      height: 64,
      fit: BoxFit.contain,
    );
  }
}

/// 簡易顯示目前分數（避免重用 ProgressPanel）
class _ScoreBadge extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(gameControllerProvider);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          '${s.goodScore}:${s.evilScore}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}

/// 封裝參數（由 QuestPage push 時傳入）
class _MissionRevealArgs {
  final int teamSize;
  final int successCount;
  final int failCount;
  _MissionRevealArgs({
    required this.teamSize,
    required this.successCount,
    required this.failCount,
  });
}
