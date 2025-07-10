import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/game_controller.dart';
import '../models/game_state.dart';
import '../models/role.dart';
import '../models/player.dart';
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
    return Scaffold(
      appBar: AppBar(title: const Text('身份揭示')),
      body: GestureDetector(
        onTap: () {
          if (!isCardVisible) setState(() => isCardVisible = true);
          else {
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
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: isCardVisible
                ? Column(
                    key: const ValueKey('card'),
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(player.role.name, style: Theme.of(context).textTheme.headlineLarge),
                      if (player.role is Merlin)
                        Text(
                          '提示：邪惡陣營 = ${state.players.where((p) => p.role.faction == Faction.evil).map((p) => p.name).join(', ')}',
                        ),
                    ],
                  )
                : Text('請將手機交給 ${player.name}', key: const ValueKey('prompt'), style: Theme.of(context).textTheme.titleLarge),
          ),
        ),
      ),
    );
  }
}