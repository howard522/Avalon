import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/game_controller.dart';
import '../models/game_state.dart';
import '../models/mission_reveal_args.dart';   // ← 共用參數類別
import 'proposal_page.dart';
import 'lady_page.dart';
import 'assassinate_page.dart';
import 'result_page.dart';

class MissionVoteRevealPage extends ConsumerStatefulWidget {
  const MissionVoteRevealPage({Key? key}) : super(key: key);

  @override
  ConsumerState<MissionVoteRevealPage> createState() =>
      _MissionVoteRevealPageState();
}

class _MissionVoteRevealPageState extends ConsumerState<MissionVoteRevealPage> {
  int revealedCount = 0;
  late int totalVotes;
  late int successVotes;
  late int failVotes;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as MissionRevealArgs?;
    // Fallback 避免 null：雖不應發生，仍保險處理
    totalVotes = args?.teamSize ?? 0;
    successVotes = args?.successCount ?? 0;
    failVotes = args?.failCount ?? 0;
  }

  @override
  Widget build(BuildContext context) {
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
        actions: const [_ScoreBadge()],
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
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                '（成功指示物會先全部揭示，再揭示失敗）',
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
    final list = <String>[
      for (int i = 0; i < successVotes; i++)
        'assets/images/token_success.png',
      for (int i = 0; i < failVotes; i++) 'assets/images/token_fail.png',
    ];
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

class _ScoreBadge extends ConsumerWidget {
  const _ScoreBadge({Key? key}) : super(key: key);

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
