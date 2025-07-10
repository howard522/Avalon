import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/game_state.dart';
import '../models/player.dart';
import '../models/role.dart';


final gameControllerProvider = StateNotifierProvider<GameController, GameState>(
  (ref) => GameController(),
);

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
      // 清空 votes
      state = state.copyWith(missionVotes: <bool>[]);
      // 根據票數進行結算
      recordMissionResult(successCount, failCount);
    }
  }

  /// 根據票數閾值更新階段和分數
  void recordMissionResult(int successCount, int failCount) {
    // 更新分數
    final newGood = state.goodScore + (successCount > failCount ? 1 : 0);
    final newEvil = state.evilScore + (failCount >= successCount ? 1 : 0);

    // 判斷是否結束
    if (newGood >= 3) {
      state = state.copyWith(
        goodScore: newGood,
        evilScore: newEvil,
        phase: GamePhase.assassinate,
      );
    } else if (newEvil >= 3) {
      state = state.copyWith(
        goodScore: newGood,
        evilScore: newEvil,
        phase: GamePhase.result,
      );
    } else {
      // 下一回合提案，領隊遞增
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
    // 找到 Merlin 的玩家 index
    final merlinIndex = state.players.indexWhere((p) => p.role is Merlin);
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
