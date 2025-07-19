import 'dart:math';
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

  /// 刪除玩家
  void removePlayer(int index) {
    final updated = List<Player>.from(state.players)..removeAt(index);
    state = state.copyWith(players: updated);
  }

  /// 分配角色並進入 Reveal，決定隨機領隊 & 初始湖中女神持有者
  void assignRoles(List<Role> roles) {
    final assigned = [
      for (var i = 0; i < state.players.length; i++)
        state.players[i].copyWith(role: roles[i]),
    ];
    final n = assigned.length;
    final randomLeader = Random().nextInt(n);
    final initialLadyHolder = (randomLeader - 1 + n) % n;

    state = state.copyWith(
      players: assigned,
      phase: GamePhase.reveal,
      leaderIndex: randomLeader,
      ladyHolderIndex: initialLadyHolder,
      ladyTargetIndex: null,
      missionHistory: const [],
      goodScore: 0,
      evilScore: 0,
      assassinationTargetIndex: null,
      isAssassinationSuccess: false,
    );
  }

  /// Reveal：下一位或轉入 Proposal
  void incrementReveal() {
    final next = state.revealIndex + 1;
    if (next >= state.players.length) {
      state = state.copyWith(phase: GamePhase.proposal, revealIndex: 0);
    } else {
      state = state.copyWith(revealIndex: next);
    }
  }

  /// 領隊提案 → 進入投票(或新流程的 vote/quest)
  void proposeTeam(List<int> teamIndices) {
    state = state.copyWith(
      proposedTeam: teamIndices,
      phase: GamePhase.vote,
    );
  }

  /// 隊伍贊成/否決
  void voteTeam(bool approved) {
    if (approved) {
      state = state.copyWith(
        phase: GamePhase.quest,
        rejectStreak: 0,
      );
    } else {
      final streak = state.rejectStreak + 1;
      if (streak >= 5) {
        // 連續 5 次否決壞人勝
        state = state.copyWith(phase: GamePhase.result, evilScore: 3);
      } else {
        state = state.copyWith(
          phase: GamePhase.proposal,
          leaderIndex: (state.leaderIndex + 1) % state.players.length,
          rejectStreak: streak,
        );
      }
    }
  }

  /// 任務成員投票 (success=true, fail=false)
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

  /// 根據票數更新分數 & 階段，並記錄歷史 missionHistory
  void recordMissionResult(int successCount, int failCount) {
    final round = state.goodScore + state.evilScore + 1;

    // 第 4 回合 7+ 人需 2 張 Fail 才失敗，否則 1 Fail 即失敗
    final failThreshold = (round == 4 && state.players.length >= 7) ? 2 : 1;
    final missionSuccess = failCount < failThreshold;

    final newGood = state.goodScore + (missionSuccess ? 1 : 0);
    final newEvil = state.evilScore + (missionSuccess ? 0 : 1);

    // append mission history
    final newHistory = List<bool>.from(state.missionHistory)
      ..add(missionSuccess);

    // 三勝判定
    if (newGood >= 3) {
      state = state.copyWith(
        goodScore: newGood,
        evilScore: newEvil,
        missionHistory: newHistory,
        phase: GamePhase.assassinate,
      );
      return;
    }
    if (newEvil >= 3) {
      state = state.copyWith(
        goodScore: newGood,
        evilScore: newEvil,
        missionHistory: newHistory,
        phase: GamePhase.result,
      );
      return;
    }

    // 湖中女神觸發 (9–10 人的第 2~4 回合)
    if (state.players.length >= 9 && round >= 2 && round <= 4) {
      final nextLeader = (state.leaderIndex + 1) % state.players.length;
      state = state.copyWith(
        goodScore: newGood,
        evilScore: newEvil,
        missionHistory: newHistory,
        phase: GamePhase.lady,
        leaderIndex: nextLeader,
        ladyTargetIndex: null,
      );
      return;
    }

    // 正常下一回合
    state = state.copyWith(
      goodScore: newGood,
      evilScore: newEvil,
      missionHistory: newHistory,
      phase: GamePhase.proposal,
      leaderIndex: (state.leaderIndex + 1) % state.players.length,
    );
  }

  /// 湖中女神：查核後傳遞
  void inspectLady(int targetIndex) {
    state = state.copyWith(
      ladyTargetIndex: targetIndex,
      ladyHolderIndex: targetIndex,
      phase: GamePhase.proposal,
    );
  }

  /// 刺殺
  void assassinate(int targetIndex) {
    final merlinIndex = state.players.indexWhere((p) => p.role is Merlin);
    final success = targetIndex == merlinIndex;
    state = state.copyWith(
      assassinationTargetIndex: targetIndex,
      isAssassinationSuccess: success,
      phase: GamePhase.result,
    );
  }

  /// 保留玩家重新開始
  void resetKeepPlayers() {
    final currentPlayers = state.players;
    state = state.copyWith(
      phase: GamePhase.setup,
      players: currentPlayers,
      leaderIndex: 0,
      revealIndex: 0,
      proposedTeam: const [],
      rejectStreak: 0,
      missionVotes: const [],
      goodScore: 0,
      evilScore: 0,
      missionHistory: const [],
      assassinationTargetIndex: null,
      isAssassinationSuccess: false,
      ladyHolderIndex: -1,
      ladyTargetIndex: null,
    );
  }

  /// 完全重置
  void reset() {
    state = const GameState();
  }
}
