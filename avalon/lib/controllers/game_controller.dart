import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/game_state.dart';
import '../models/player.dart';
import '../models/role.dart';
import '../models/team_size_factory.dart';
import '../controllers/game_controller.dart';
import '../widgets/progress_panel.dart';

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
      // 通過 → 清零否決連續計數，進入任務階段
      state = state.copyWith(
        phase: GamePhase.quest,
        rejectStreak: 0,
      );
    } else {
      // 否決 → 增加一次連續否決
      final streak = state.rejectStreak + 1;
      if (streak >= 5) {
        // 連續 5 次否決 → 壞人勝利
        state = state.copyWith(
          phase: GamePhase.result,
        );
      } else {
        // 換下一位領隊，回到提名階段
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

  /// 根據票數閾值更新階段和分數
  void recordMissionResult(int successCount, int failCount) {
    final round = state.goodScore + state.evilScore + 1;
    final failThreshold =
        (round == 4 && state.players.length >= 7) ? 2 : 1;
    final missionSuccess = failCount < failThreshold;

    final newGood = state.goodScore + (missionSuccess ? 1 : 0);
    final newEvil = state.evilScore + (missionSuccess ? 0 : 1);

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
