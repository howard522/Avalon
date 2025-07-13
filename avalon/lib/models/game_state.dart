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
  lady,          // 新增：湖中女神階段
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

    // 湖中女神相關
    @Default(-1) int ladyHolderIndex,    // 持有湖中女神者
    int? ladyTargetIndex,                // 被查核的玩家索引

    int? assassinationTargetIndex,
    @Default(false) bool isAssassinationSuccess,
  }) = _GameState;

  factory GameState.fromJson(Map<String, dynamic> json) =>
      _$GameStateFromJson(json);
}
