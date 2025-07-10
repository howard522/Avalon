// lib/pages/reveal_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/game_controller.dart';
import '../models/game_state.dart';
import '../models/role.dart';
import '../models/player.dart';
import 'proposal_page.dart';
import '../widgets/progress_panel.dart';

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
      if (role is Oberon) {
        return '你是不會被其他壞人或梅林識別的壞人。';
      }
      if (role.faction == Faction.evil) {
        // 非 Oberon 壞人可見所有壞人隊友
        final teammates = state.players
            .asMap()
            .entries
            .where((e) =>
                e.key != state.revealIndex &&
                e.value.role.faction == Faction.evil)
            .map((e) => e.value.name)
            .join(', ');
        return '你的隊友: $teammates';
      }
      if (role is Merlin) {
        // Merlin 可見所有壞人但排除 Mordred 與 Oberon
        final visible = state.players
            .where((p) =>
                p.role.faction == Faction.evil &&
                p.role is! Mordred &&
                p.role is! Oberon)
            .map((p) => p.name)
            .join(', ');
        return '你看見的壞人: $visible';
      }
      if (role is Percival) {
        // Percival 可見 Merlin 與 Morgana，但不分辨
        final candidates = state.players
            .where((p) => p.role is Merlin || p.role is Morgana)
            .map((p) => p.name)
            .join(', ');
        return '你看見: $candidates，其中一人是梅林';
      }
      // 忠臣
      return '你是忠臣，無特殊能力。';
    }

    String roleDesc() {
      final r = player.role;
      if (r is Merlin) {
        return '梅林：好人中唯一可見大部分壞人，但須保密身份。';
      }
      if (r is Percival) {
        return '帕西維爾：可看見梅林或摩甘娜的幻象，需要保護梅林。';
      }
      if (r is LoyalServant) {
        return '忠臣：無特殊能力，支持好人完成任務。';
      }
      if (r is Assassin) {
        return '刺客：壞人核心；好人三勝後可刺殺梅林。';
      }
      if (r is Morgana) {
        return '摩甘娜：對帕西維爾呈現幻象，可辨識其他壞人。';
      }
      if (r is Mordred) {
        return '莫德雷德：不被梅林偵測，可辨識其他壞人。';
      }
      if (r is Oberon) {
        return '奧伯倫：不被其他壞人或梅林識別，行動獨立。';
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
