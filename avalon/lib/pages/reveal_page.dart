// lib/pages/reveal_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/game_controller.dart';
import '../models/game_state.dart';
import '../models/role.dart';
import '../models/player.dart';
import '../widgets/progress_panel.dart';
import 'proposal_page.dart';

class RevealPage extends ConsumerStatefulWidget {
  const RevealPage({Key? key}) : super(key: key);

  @override
  ConsumerState<RevealPage> createState() => _RevealPageState();
}

class _RevealPageState extends ConsumerState<RevealPage> {
  bool isCardVisible = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameControllerProvider);
    final player = state.players[state.revealIndex];

    String extraInfo() {
      final role = player.role;
      // Oberon
      if (role is Oberon) {
        return '你是奧伯倫：不被其他壞人或梅林識別，也不知道隊友。';
      }
      // 其他壞人（含爪牙、刺客、摩甘娜、莫德雷德）
      if (role.faction == Faction.evil) {
        final teammates = state.players
            .where((p) =>
                p.role.faction == Faction.evil &&
                p.role is! Oberon &&
                p != player)
            .map((p) => p.name)
            .join(', ');
        return '你的隊友: $teammates';
      }
      // Merlin
      if (role is Merlin) {
        final visible = state.players
            .where((p) =>
                p.role.faction == Faction.evil &&
                p.role is! Mordred &&
                p.role is! Oberon)
            .map((p) => p.name)
            .join(', ');
        return '你看見的壞人: $visible';
      }
      // Percival
      if (role is Percival) {
        final candidates = state.players
            .where((p) => p.role is Merlin || p.role is Morgana)
            .map((p) => p.name)
            .join(', ');
        return '你看見: $candidates，其中一人是梅林';
      }
      // 好人
      return '你是忠臣：無特殊能力。';
    }

    String roleDesc() {
      final r = player.role;
      if (r is Merlin) {
        return '梅林：可見所有壞人（不含莫德雷德與奧伯倫），須保密身份。';
      }
      if (r is Percival) {
        return '帕西維爾：可見梅林與摩甘娜的幻象，需保護梅林。';
      }
      if (r is LoyalServant) {
        return '忠臣：無特殊能力，支持好人完成任務。';
      }
      if (r is Assassin) {
        return '刺客：壞人核心，好人三勝後可刺殺梅林。';
      }
      if (r is Morgana) {
        return '摩甘娜：呈現梅林幻象，可辨識其他壞人（不含奧伯倫）。';
      }
      if (r is Mordred) {
        return '莫德雷德：梅林無法偵測，可辨識其他壞人（不含奧伯倫）。';
      }
      if (r is Oberon) {
        return '奧伯倫：不被其他壞人或梅林識別，行動獨立。';
      }
      if (r is Minion) {
        return '爪牙：無特殊能力的壞人同伴，但不會被特殊角色識別。';
      }
      return '';
    }

    return Scaffold(
      appBar: const ProgressPanel(),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (!isCardVisible) {
            setState(() => isCardVisible = true);
          } else {
            ref.read(gameControllerProvider.notifier).incrementReveal();
            setState(() => isCardVisible = false);
            if (state.revealIndex + 1 >= state.players.length) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const ProposalPage()),
              );
            }
          }
        },
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: isCardVisible
                ? Column(
                    key: const ValueKey('card'),
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        player.role.name,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        extraInfo(),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        roleDesc(),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  )
                : Text(
                    '請將手機交給 ${player.name}',
                    key: const ValueKey('prompt'),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
          ),
        ),
      ),
    );
  }
}
