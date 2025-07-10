// lib/controllers/game_controller.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/game_state.dart';
import '../models/player.dart';
import '../models/role.dart';

final gameControllerProvider =
    StateNotifierProvider<GameController, GameState>((ref) => GameController());

class GameController extends StateNotifier<GameState> {
  GameController() : super(const GameState());

  /// 加入玩家
  void addPlayer(String name) {
    final updated = List<Player>.from(state.players)
      ..add(Player(name: name, role: const Role.loyalServant()));
    state = state.copyWith(players: updated);
  }

  /// 分配角色並進入 Reveal 階段
  void assignRoles(List<Role> roles) {
    final assigned = [
      for (var i = 0; i < state.players.length; i++)
        state.players[i].copyWith(role: roles[i]),
    ];
    state = state.copyWith(players: assigned, phase: GamePhase.reveal);
  }

  /// Reveal 階段：前進到下一位或進入 Proposal
  void incrementReveal() {
    final next = state.revealIndex + 1;
    if (next >= state.players.length) {
      state = state.copyWith(phase: GamePhase.proposal, revealIndex: 0);
    } else {
      state = state.copyWith(revealIndex: next);
    }
  }

  /// 提案隊伍並進入 Quest 階段
  void proposeTeam(List<int> teamIndices) {
    state = state.copyWith(proposedTeam: teamIndices, phase: GamePhase.quest);
  }

  /// 隊伍成員提交任務投票 Success(true)/Fail(false)
  void submitMissionVote(bool success) {
    final updated = List<bool>.from(state.missionVotes)..add(success);
    state = state.copyWith(missionVotes: updated);
    if (updated.length >= state.proposedTeam.length) {
      final successCount = updated.where((v) => v).length;
      final failCount = updated.length - successCount;
      // 清空本輪投票
      state = state.copyWith(missionVotes: <bool>[]);
      // 根據票數進行結算
      recordMissionResult(successCount, failCount);
    }
  }

  /// 根據票數閾值更新階段和分數
  void recordMissionResult(int successCount, int failCount) {
    // 計算目前是第幾回合 (從1開始)
    final round = state.goodScore + state.evilScore + 1;
    // 第4回合且人數>=7時需2張失敗票才算失敗，否則1張即算失敗
    final failThreshold = (round == 4 && state.players.length >= 7) ? 2 : 1;
    final missionSuccess = failCount < failThreshold;

    final newGood = state.goodScore + (missionSuccess ? 1 : 0);
    final newEvil = state.evilScore + (missionSuccess ? 0 : 1);

    if (newGood >= 3) {
      // 好人取得三次成功，進入刺殺階段
      state = state.copyWith(
        goodScore: newGood,
        evilScore: newEvil,
        phase: GamePhase.assassinate,
      );
    } else if (newEvil >= 3) {
      // 邪惡取得三次失敗，遊戲結束
      state = state.copyWith(
        goodScore: newGood,
        evilScore: newEvil,
        phase: GamePhase.result,
      );
    } else {
      // 進入下一回合提案，換下一位領隊
      state = state.copyWith(
        goodScore: newGood,
        evilScore: newEvil,
        phase: GamePhase.proposal,
        leaderIndex: (state.leaderIndex + 1) % state.players.length,
      );
    }
  }

  /// 刺殺行動：Assassin 選擇目標，判定是否為 Merlin
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

  /// 重置遊戲狀態
  void reset() {
    state = const GameState();
  }
}
