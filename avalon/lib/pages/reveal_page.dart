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
  bool _busy = false; // 防止快速連點

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameControllerProvider);
    final controller = ref.read(gameControllerProvider.notifier);
    final idx = state.revealIndex;
    final player = state.players[idx];

    String extraInfo() {
      final role = player.role;
      if (role is Oberon) return '你是奧伯倫：不被其他壞人識別，但是會被梅林識別，也不知道隊友。';
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
                p.role is! Mordred )
            .map((p) => p.name)
            .join(', ');
        return '你看見的壞人：$visibles';
      }
      if (role is Percival) {
        final candidates = state.players
            .where((p) => p.role is Merlin || p.role is Morgana)
            .map((p) => p.name)
            .join(', ');
        return '你看見：$candidates其中一人是梅林';
      }
      return '你是忠臣：無特殊能力。';
    }

    String roleDesc() => player.role.name + '：' + player.role.map(
          merlin: (_) => '可見所有壞人（不含莫德雷德），須保密身份',
          percival: (_) => '可見梅林與摩甘娜幻象，需保護梅林',
          loyalServant: (_) => '無特殊能力，支持好人完成任務',
          assassin: (_) => '好人三勝後可刺殺梅林',
          morgana: (_) => '呈現梅林幻象，可見其他壞人（不含奧伯倫）',
          mordred: (_) => '梅林無法偵測，可見其他壞人（不含奧伯倫）',
          oberon: (_) => '不認得其他壞人，但會被梅林識別',
          minion: (_) => '不被梅林識別',
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text('身份揭示'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text(
            '請將手機交給：${player.name}\n點擊卡牌翻開查看身份',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
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
                    child: _CardSurface.front(),
                  ),
                  back: GestureDetector(
                    onTap: () {
                      if (_busy) return;
                      _busy = true;
                      final isLast = state.revealIndex == state.players.length - 1;

                      _cardKey.currentState?.toggleCard();
                      Future.delayed(const Duration(milliseconds: 250), () {
                        if (isLast) {
                          // 最後一位：不再呼叫 incrementReveal()，直接進入下一階段
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProposalPage(),
                            ),
                          );
                        } else {
                          // 不是最後一位：才遞增
                          controller.incrementReveal();
                          setState(() => _busy = false);
                        }
                      });
                    },
                    child: _CardSurface.back(
                      role: player.role,
                      extraInfo: extraInfo(),
                      roleDesc: roleDesc(),
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

/// 卡牌外觀：front / back
class _CardSurface extends StatelessWidget {
  final bool isBack;
  final Role? role;
  final String? extraInfo;
  final String? roleDesc;

  const _CardSurface.front()
      : isBack = false,
        role = null,
        extraInfo = null,
        roleDesc = null;

  const _CardSurface.back({
    required this.role,
    required this.extraInfo,
    required this.roleDesc,
  }) : isBack = true;

  String _roleAsset(Role r) {
    return r.map(
      merlin: (_) => 'assets/images/role_merlin.png',
      percival: (_) => 'assets/images/role_percival.png',
      loyalServant: (_) => 'assets/images/role_loyal.png',
      assassin: (_) => 'assets/images/role_assassin.png',
      morgana: (_) => 'assets/images/role_morgana.png',
      mordred: (_) => 'assets/images/role_mordred.png',
      oberon: (_) => 'assets/images/role_oberon.png',
      minion: (_) => 'assets/images/role_minion.png',
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            isBack
                ? 'assets/images/card_front_placeholder.png'
                : 'assets/images/card_back.png',
          ),
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
      padding: const EdgeInsets.all(18),
      child: isBack ? _buildBackContent(context) : const SizedBox.shrink(),
    );
  }

  Widget _buildBackContent(BuildContext context) {
    final r = role!;
    final path = _roleAsset(r);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _RoleAvatar(role: r, assetPath: path),
        const SizedBox(height: 16),
        Text(
          r.name,
          style: const TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 14),
        Text(
          extraInfo ?? '',
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black87,
            height: 1.3,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          roleDesc ?? '',
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
            height: 1.3,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 22),
        const Text(
          '（點擊卡牌交給下一位）',
          style: TextStyle(
            fontSize: 12,
            color: Colors.black45,
          ),
        ),
      ],
    );
  }
}

class _RoleAvatar extends StatelessWidget {
  final Role role;
  final String assetPath;
  const _RoleAvatar({
    Key? key,
    required this.role,
    required this.assetPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset(
        assetPath,
        width: 120,
        height: 120,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: 120,
          height: 120,
          color: Colors.grey[300],
          alignment: Alignment.center,
          child: Text(
            role.name.characters.first.toUpperCase(),
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ),
      ),
    );
  }
}
