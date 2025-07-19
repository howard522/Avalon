import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flip_card/flip_card.dart';

import '../controllers/game_controller.dart';
import '../models/role.dart';
import 'proposal_page.dart';

class RevealPage extends ConsumerStatefulWidget {
  const RevealPage({Key? key}) : super(key: key);

  @override
  ConsumerState<RevealPage> createState() => _RevealPageState();
}

class _RevealPageState extends ConsumerState<RevealPage> {
  final GlobalKey<FlipCardState> _cardKey = GlobalKey<FlipCardState>();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameControllerProvider);
    final controller = ref.read(gameControllerProvider.notifier);
    final player = state.players[state.revealIndex];

    String extraInfo() {
      final role = player.role;
      if (role is Oberon) return '你是奧伯倫：不被其他壞人或梅林識別，也不知道隊友。';
      if (role.faction == Faction.evil) {
        final mates = state.players
            .where((p) =>
                p.role.faction == Faction.evil &&
                p.role is! Oberon &&
                p != player)
            .map((p) => p.name)
            .join(', ');
        return mates.isEmpty ? '沒有隊友可見' : '你的隊友：$mates';
      }
      if (role is Merlin) {
        final visibles = state.players
            .where((p) =>
                p.role.faction == Faction.evil &&
                p.role is! Mordred &&
                p.role is! Oberon)
            .map((p) => p.name)
            .join(', ');
        return '你看見的壞人：$visibles';
      }
      if (role is Percival) {
        final candidates = state.players
            .where((p) => p.role is Merlin || p.role is Morgana)
            .map((p) => p.name)
            .join(', ');
        return '你看見：$candidates，其中一人是梅林';
      }
      return '你是忠臣：無特殊能力。';
    }

    String roleDesc() => player.role.name + '：' + player.role.map(
          merlin: (_) => '可見所有壞人（不含莫德雷德），須保密身份。',
          percival: (_) => '可見梅林與摩甘娜幻象，需保護梅林。',
          loyalServant: (_) => '無特殊能力，支持好人完成任務。',
          assassin: (_) => '好人三勝後可刺殺梅林。',
          morgana: (_) => '呈現梅林幻象，可見其他壞人（不含奧伯倫）。',
          mordred: (_) => '梅林無法偵測，可見其他壞人（不含奧伯倫）。',
          oberon: (_) => '不被其他壞人或梅林識別，行動獨立。',
          minion: (_) => '無特殊能力，但不被特殊角色識別。',
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text('身份揭示'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '請將手機交給\n${player.name}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            FlipCard(
              key: _cardKey,
              flipOnTouch: true,
              direction: FlipDirection.HORIZONTAL,
              front: GestureDetector(
                onTap: () => _cardKey.currentState?.toggleCard(),
                child: Container(
                  width: 360,
                  height: 540,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/images/card_back.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              back: GestureDetector(
                onTap: () {
                  _cardKey.currentState?.toggleCard();
                  controller.incrementReveal();
                  if (state.revealIndex + 1 >= state.players.length) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ProposalPage(),
                      ),
                    );
                  }
                },
                child: Container(
                  width: 360,
                  height: 540,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage(
                          'assets/images/card_front_placeholder.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        player.role.name,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        extraInfo(),
                        style:
                            const TextStyle(fontSize: 18, color: Colors.black87),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        roleDesc(),
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black54),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
