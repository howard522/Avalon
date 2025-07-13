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

  /// 分配角色並進入 Reveal 階段，同時決定亂數起始領隊與初始湖中女神持有者
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
    );
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

  /// 提案隊伍 → 先進入投票階段
  void proposeTeam(List<int> teamIndices) {
    state = state.copyWith(
      proposedTeam: teamIndices,
      phase: GamePhase.vote,
    );
  }

  /// 處理隊伍投票是否通過
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

  /// 隊伍成員提交任務投票 Success(true)/Fail(false)
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

  /// 根據票數更新階段和分數，並在第 2、3、4 回合(9-10 人局)觸發湖中女神
  void recordMissionResult(int successCount, int failCount) {
    final round = state.goodScore + state.evilScore + 1;
    final failThreshold = (round == 4 && state.players.length >= 7) ? 2 : 1;
    final missionSuccess = failCount < failThreshold;

    final newGood = state.goodScore + (missionSuccess ? 1 : 0);
    final newEvil = state.evilScore + (missionSuccess ? 0 : 1);

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

    if (state.players.length >= 9 && round >= 2 && round <= 4) {
      final nextLeader = (state.leaderIndex + 1) % state.players.length;
      state = state.copyWith(
        goodScore: newGood,
        evilScore: newEvil,
        phase: GamePhase.lady,
        leaderIndex: nextLeader,
        ladyTargetIndex: null,
      );
      return;
    }

    state = state.copyWith(
      goodScore: newGood,
      evilScore: newEvil,
      phase: GamePhase.proposal,
      leaderIndex: (state.leaderIndex + 1) % state.players.length,
    );
  }

  /// 湖中女神：持有者點選目標，查看並傳承
  void inspectLady(int targetIndex) {
    state = state.copyWith(
      ladyTargetIndex: targetIndex,
      ladyHolderIndex: targetIndex,
      phase: GamePhase.proposal,
    );
  }

  /// 刺殺行動：Assassin 選擇目標並判定
  void assassinate(int targetIndex) {
    final merlinIndex = state.players.indexWhere((p) => p.role is Merlin);
    final success = targetIndex == merlinIndex;
    state = state.copyWith(
      assassinationTargetIndex: targetIndex,
      isAssassinationSuccess: success,
      phase: GamePhase.result,
    );
  }

  /// 重置並保留玩家名單
  void resetKeepPlayers() {
    final currentPlayers = state.players;
    state = state.copyWith(
      phase: GamePhase.setup,
      players: currentPlayers,
      leaderIndex: 0,
      revealIndex: 0,
      proposedTeam: [],
      rejectStreak: 0,
      missionVotes: [],
      goodScore: 0,
      evilScore: 0,
      assassinationTargetIndex: null,
      isAssassinationSuccess: false,
      ladyHolderIndex: -1,
      ladyTargetIndex: null,
    );
  }

  /// 重置遊戲並清空玩家名單
  void reset() {
    state = const GameState();
  }
}