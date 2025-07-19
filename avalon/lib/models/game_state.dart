import 'package:freezed_annotation/freezed_annotation.dart';
import 'player.dart';

part 'game_state.freezed.dart';
part 'game_state.g.dart';

/// 遊戲所處階段
enum GamePhase {
  setup,
  reveal,
  proposal,
  vote,
  quest,
  lady,          // 湖中女神階段
  assassinate,
  result,
}

@freezed
abstract class GameState with _$GameState {
  const factory GameState({
    @Default(GamePhase.setup) GamePhase phase,
    @Default(<Player>[]) List<Player> players,
    @Default(0) int leaderIndex,
    @Default(0) int revealIndex,
    @Default(<int>[]) List<int> proposedTeam,
    @Default(0) int rejectStreak,
    @Default(<bool>[]) List<bool> missionVotes,
    @Default(0) int goodScore,
    @Default(0) int evilScore,

    /// 已完成任務歷史：每一回合結束時 push
    /// true = 任務成功；false = 任務失敗
    @Default(<bool>[]) List<bool> missionHistory,

    // 湖中女神相關
    @Default(-1) int ladyHolderIndex,
    int? ladyTargetIndex,

    int? assassinationTargetIndex,
    @Default(false) bool isAssassinationSuccess,
  }) = _GameState;

  factory GameState.fromJson(Map<String, dynamic> json) =>
      _$GameStateFromJson(json);
}
