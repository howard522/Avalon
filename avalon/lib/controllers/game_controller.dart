// lib/controllers/game_controller.dart

import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/game_state.dart';
import '../models/player.dart';
import '../models/role.dart';

/// 遊戲控制器 Provider
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
    // 累加本回合的投票結果
    final updated = List<bool>.from(state.missionVotes)..add(success);
    state = state.copyWith(missionVotes: updated);

    // 如果所有隊員都已投票，進行結果處理
    if (updated.length >= state.proposedTeam.length) {
      final successCount = updated.where((v) => v).length;
      final failCount = updated.length - successCount;

      // 清空當回合暫存
      state = state.copyWith(missionVotes: <bool>[]);

      // 使用統一邏輯記錄歷史與分數
      _recordMissionResult(successCount, failCount);
    }
  }

  void _recordMissionResult(int successCount, int failCount) {
    final round = state.goodScore + state.evilScore + 1;
    // 第 4 回合（7 人以上）需要 2 張失敗才算任務失敗，其餘只要 1 張即可
    final failThreshold = (round == 4 && state.players.length >= 7) ? 2 : 1;
    final missionSuccess = failCount < failThreshold;

    // 1) 記錄歷史結果
    final newHistory = List<bool>.from(state.missionHistory)
      ..add(missionSuccess);
    // 2) 更新分數
    final newGood = state.goodScore + (missionSuccess ? 1 : 0);
    final newEvil = state.evilScore + (missionSuccess ? 0 : 1);

    // 串接新的狀態
    // 如果好人達 3 勝：進入刺殺階段
    if (newGood >= 3) {
      state = state.copyWith(
        missionHistory: newHistory,
        goodScore: newGood,
        evilScore: newEvil,
        phase: GamePhase.assassinate,
      );
      return;
    }
    // 如果壞人達 3 勝：直接結算
    if (newEvil >= 3) {
      state = state.copyWith(
        missionHistory: newHistory,
        goodScore: newGood,
        evilScore: newEvil,
        phase: GamePhase.result,
      );
      return;
    }

    // 否則，更新到下一階段（Lake 或 Proposal）
    final canEnterLady = state.ladyEnabled && round >= 2 && round <= 4;
    if (canEnterLady) {
      state = state.copyWith(
        missionHistory: newHistory,
        goodScore: newGood,
        evilScore: newEvil,
        phase: GamePhase.lady,
        leaderIndex: (state.leaderIndex + 1) % state.players.length,
        ladyTargetIndex: null,
      );
    } else {
      state = state.copyWith(
        missionHistory: newHistory,
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
    final merlinIndex =
        state.players.indexWhere((p) => p.role is Merlin);
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
