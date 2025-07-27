import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/game_state.dart';
import '../models/player.dart';
import '../models/role.dart';

/// 正確的寫法：閉包要帶 ref
final gameControllerProvider =
    StateNotifierProvider<GameController, GameState>((ref) => GameController());

class GameController extends StateNotifier<GameState> {
  GameController() : super(const GameState());

  // ───────────────────────── 玩家管理 ─────────────────────────
  void addPlayer(String name) {
    final updated = List<Player>.from(state.players)
      ..add(Player(name: name, role: const Role.loyalServant()));
    state = state.copyWith(players: updated);
  }

  void removePlayer(int index) {
    final updated = List<Player>.from(state.players)..removeAt(index);
    state = state.copyWith(players: updated);
  }

  // ───────────────────────── 設定項目 ─────────────────────────
  void setLadyEnabled(bool enabled) =>
      state = state.copyWith(ladyEnabled: enabled);

  // ───────────────────────── 開始遊戲 ─────────────────────────
  void assignRoles(List<Role> roles) {
    final assigned = [
      for (var i = 0; i < state.players.length; i++)
        state.players[i].copyWith(role: roles[i]),
    ];

    final n = assigned.length;
    final randomLeader = Random().nextInt(n);
    final initialLadyHolder =
        state.ladyEnabled ? (randomLeader - 1 + n) % n : -1;

    state = state.copyWith(
      players: assigned,
      phase: GamePhase.reveal,
      leaderIndex: randomLeader,
      revealIndex: 0,
      ladyHolderIndex: initialLadyHolder,
      ladyTargetIndex: null,
    );
  }

  // ───────────────────────── Reveal ─────────────────────────
  void incrementReveal() {
    final next = state.revealIndex + 1;
    if (next >= state.players.length) {
      state = state.copyWith(phase: GamePhase.proposal, revealIndex: 0);
    } else {
      state = state.copyWith(revealIndex: next);
    }
  }

  // ───────────────────────── Proposal / Vote ─────────────────────────
  void proposeTeam(List<int> teamIndices) =>
      state = state.copyWith(proposedTeam: teamIndices, phase: GamePhase.vote);

  void voteTeam(bool approved) {
    if (approved) {
      state = state.copyWith(phase: GamePhase.quest, rejectStreak: 0);
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

  // ───────────────────────── Quest 投票 ─────────────────────────
  void submitMissionVote(bool success) {
    final updated = List<bool>.from(state.missionVotes)..add(success);
    state = state.copyWith(missionVotes: updated);

    if (updated.length >= state.proposedTeam.length) {
      final successCount = updated.where((v) => v).length;
      final failCount = updated.length - successCount;

      // 清空當回合暫存
      state = state.copyWith(missionVotes: <bool>[]);

      // 記錄歷史（成功 true / 失敗 false）
      final history = List<bool>.from(state.missionHistory)
        ..add(successCount > failCount);
      state = state.copyWith(missionHistory: history);

      _recordMissionResult(successCount, failCount);
    }
  }

  void _recordMissionResult(int successCount, int failCount) {
    final round = state.goodScore + state.evilScore + 1;
    final failThreshold =
        (round == 4 && state.players.length >= 7) ? 2 : 1;
    final missionSuccess = failCount < failThreshold;

    final newGood = state.goodScore + (missionSuccess ? 1 : 0);
    final newEvil = state.evilScore + (missionSuccess ? 0 : 1);

    // 遊戲是否結束
    if (newGood >= 3) {
      state = state.copyWith(
        goodScore: newGood,
        evilScore: newEvil,
        phase: GamePhase.assassinate,
      );
      return;
    }
    if (newEvil >= 3) {
      state = state.copyWith(
        goodScore: newGood,
        evilScore: newEvil,
        phase: GamePhase.result,
      );
      return;
    }

    // 湖中女神條件
    final canEnterLady = state.ladyEnabled &&
        state.players.length >= 9 &&
        round >= 2 &&
        round <= 4;

    if (canEnterLady) {
      state = state.copyWith(
        goodScore: newGood,
        evilScore: newEvil,
        phase: GamePhase.lady,
        leaderIndex: (state.leaderIndex + 1) % state.players.length,
        ladyTargetIndex: null,
      );
    } else {
      state = state.copyWith(
        goodScore: newGood,
        evilScore: newEvil,
        phase: GamePhase.proposal,
        leaderIndex: (state.leaderIndex + 1) % state.players.length,
      );
    }
  }

  // ───────────────────────── Lady of the Lake ─────────────────────────
  void inspectLady(int targetIndex) {
    state = state.copyWith(
      ladyTargetIndex: targetIndex,
      ladyHolderIndex: targetIndex,
      phase: GamePhase.proposal,
    );
  }

  // ───────────────────────── 刺客 ─────────────────────────
  void assassinate(int targetIndex) {
    final merlinIndex = state.players.indexWhere((p) => p.role is Merlin);
    final success = targetIndex == merlinIndex;
    state = state.copyWith(
      assassinationTargetIndex: targetIndex,
      isAssassinationSuccess: success,
      phase: GamePhase.result,
    );
  }

  // ───────────────────────── Reset ─────────────────────────
  void resetKeepPlayers() {
    state = state.copyWith(
      phase: GamePhase.setup,
      leaderIndex: 0,
      revealIndex: 0,
      proposedTeam: [],
      rejectStreak: 0,
      missionVotes: [],
      goodScore: 0,
      evilScore: 0,
      assassinationTargetIndex: null,
      isAssassinationSuccess: false,
      ladyHolderIndex: state.ladyEnabled ? 0 : -1,
      ladyTargetIndex: null,
      missionHistory: [],
    );
  }

  void reset() => state = const GameState();
}
