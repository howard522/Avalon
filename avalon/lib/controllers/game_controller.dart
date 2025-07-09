import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/game_state.dart';
import '../models/player.dart';
import '../models/role.dart';

final gameControllerProvider =
    StateNotifierProvider<GameController, GameState>(
  (ref) => GameController(),
);

class GameController extends StateNotifier<GameState> {
  GameController() : super(const GameState());

  /* ---------- Setup Phase ---------- */
  void addPlayer(String name) {
    final updated = List<Player>.from(state.players)
      ..add(Player(name: name, role: const Role.loyalServant()));
    state = state.copyWith(players: updated);
  }

  void assignRoles(List<Role> roles) {
    // 假設 roles 長度與 players 相等
    final assigned = [
      for (var i = 0; i < state.players.length; i++)
        state.players[i].copyWith(role: roles[i]),
    ];
    state = state.copyWith(players: assigned, phase: GamePhase.reveal);
  }

  /* ---------- Phase Transitions ---------- */
  void nextPhase(GamePhase target) => state = state.copyWith(phase: target);
  void incrementReveal() {
    final next = state.revealIndex + 1;
    if (next >= state.players.length) {
      state = state.copyWith(
        phase: GamePhase.proposal,
        revealIndex: 0, // 重置
      );
    } else {
      state = state.copyWith(revealIndex: next);
    }
  }

}
