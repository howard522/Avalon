import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flip_card/flip_card.dart';

import '../controllers/game_controller.dart';
import '../models/role.dart';
import '../widgets/role_identity_card.dart';
import '../services/role_info_service.dart';
import '../constants/assets.dart';
import 'proposal_page.dart';

class RevealPage extends ConsumerStatefulWidget {
  const RevealPage({Key? key}) : super(key: key);

  @override
  ConsumerState<RevealPage> createState() => _RevealPageState();
}

class _RevealPageState extends ConsumerState<RevealPage> {
  final GlobalKey<FlipCardState> _cardKey = GlobalKey<FlipCardState>();
  bool _busy = false;
  final _roleInfoService = RoleInfoService();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameControllerProvider);
    final controller = ref.read(gameControllerProvider.notifier);
    final idx = state.revealIndex;
    final player = state.players[idx];
    final info = _roleInfoService.build(self: player, all: state.players);

    return Scaffold(
      appBar: AppBar(
        title: const Text('身份揭示'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          Text(
            '請將手機交給：${player.name}\n點擊卡牌翻開查看身份',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: SizedBox(
                width: 360,
                height: 560,
                child: FlipCard(
                  key: _cardKey,
                  flipOnTouch: true,
                  direction: FlipDirection.HORIZONTAL,
                  front: GestureDetector(
                    onTap: () {
                      if (_busy) return;
                      _cardKey.currentState?.toggleCard();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(AppAssets.images.cardBack),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.18),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                    ),
                  ),
                  back: GestureDetector(
                    onTap: () {
                      if (_busy) return;
                      _busy = true;
                      final isLast =
                          state.revealIndex == state.players.length - 1;

                      _cardKey.currentState?.toggleCard();
                      Future.delayed(const Duration(milliseconds: 250), () {
                        if (isLast) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProposalPage(),
                            ),
                          );
                        } else {
                          controller.incrementReveal();
                          setState(() => _busy = false);
                        }
                      });
                    },
                    child: RoleIdentityCard(
                      role: player.role,
                      extraInfo: info.extraInfo,
                      roleDesc: info.description,
                      bottomHint: '（點擊卡牌交給下一位）',
                      scrollable: true,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
