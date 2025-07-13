import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/game_state.dart';
import '../models/player.dart';
import '../models/role.dart';

final gameControllerProvider =
    StateNotifierProvider<GameController, GameState>((ref) => GameController());

class GameController extends StateNotifier<GameState> {
  GameController() : super(const GameState());

  void addPlayer(String name) {
    final updated = List<Player>.from(state.players)
      ..add(Player(name: name, role: const Role.loyalServant()));
    state = state.copyWith(players: updated);
  }

  void assignRoles(List<Role> roles) {
    final assigned = [
      for (var i = 0; i < state.players.length; i++)
        state.players[i].copyWith(role: roles[i]),
    ];
    state = state.copyWith(players: assigned, phase: GamePhase.reveal);
  }

  void incrementReveal() {
    final next = state.revealIndex + 1;
    if (next >= state.players.length) {
      state = state.copyWith(phase: GamePhase.proposal, revealIndex: 0);
    } else {
      state = state.copyWith(revealIndex: next);
    }
  }

  void proposeTeam(List<int> teamIndices) {
    state = state.copyWith(
      proposedTeam: teamIndices,
      phase: GamePhase.vote,
    );
  }

  void voteTeam(bool approved) {
    if (approved) {
      state = state.copyWith(
        phase: GamePhase.quest,
        rejectStreak: 0,
      );
    } else {
      final streak = state.rejectStreak + 1;
      if (streak >= 5) {
        state = state.copyWith(phase: GamePhase.result);
      } else {
        state = state.copyWith(
          phase: GamePhase.proposal,
          leaderIndex: (state.leaderIndex + 1) % state.players.length,
          rejectStreak: streak,
        );
      }
    }
  }

  void submitMissionVote(bool success) {
    final updated = List<bool>.from(state.missionVotes)..add(success);
    state = state.copyWith(missionVotes: updated);
    if (updated.length >= state.proposedTeam.length) {
      final successCount = updated.where((v) => v).length;
      final failCount = updated.length - successCount;
      state = state.copyWith(missionVotes: <bool>[]);
      recordMissionResult(successCount, failCount);
    }
  }

  void recordMissionResult(int successCount, int failCount) {
    final round = state.goodScore + state.evilScore + 1;
    final failThreshold =
        (round == 4 && state.players.length >= 7) ? 2 : 1;
    final missionSuccess = failCount < failThreshold;

    final newGood = state.goodScore + (missionSuccess ? 1 : 0);
    final newEvil = state.evilScore + (missionSuccess ? 0 : 1);

    // 判定好壞人勝利或進入刺殺
    if (newGood >= 3) {
      state = state.copyWith(
        goodScore: newGood,
        evilScore: newEvil,
        phase: GamePhase.assassinate,
      );
      return;
    } else if (newEvil >= 3) {
      state = state.copyWith(
        goodScore: newGood,
        evilScore: newEvil,
        phase: GamePhase.result,
      );
      return;
    }

    // 非 9-10 人局或非第2回合，回到提名
    final nextLeader = (state.leaderIndex + 1) % state.players.length;
    if (!(state.players.length >= 9 && round == 2)) {
      state = state.copyWith(
        goodScore: newGood,
        evilScore: newEvil,
        phase: GamePhase.proposal,
        leaderIndex: nextLeader,
      );
      return;
    }

    // 9、10 人第2回合：進入湖中女神階段
    state = state.copyWith(
      goodScore: newGood,
      evilScore: newEvil,
      phase: GamePhase.lady,
      leaderIndex: nextLeader,
      ladyHolderIndex: nextLeader,
      ladyTargetIndex: null,
    );
  }

  /// 湖中女神：查看目標玩家陣營，然後回到提名
  void inspectLady(int targetIndex) {
    state = state.copyWith(
      ladyTargetIndex: targetIndex,
      phase: GamePhase.proposal,
    );
  }

  void assassinate(int targetIndex) {
    final merlinIndex =
        state.players.indexWhere((p) => p.role is Merlin);
    final success = targetIndex == merlinIndex;

    state = state.copyWith(
      assassinationTargetIndex: targetIndex,
      isAssassinationSuccess: success,
      phase: GamePhase.result,
    );
  }

  void reset() {
    state = const GameState();
  }
}
