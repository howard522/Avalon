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
  lady,          // 湖中女神階段（可關閉）
  assassinate,
  result,
}

@freezed
abstract class GameState with _$GameState {
  const factory GameState({
    // ───────────────────────────────── 基本流程 ─────────────────────────────────
    @Default(GamePhase.setup) GamePhase phase,
    @Default(<Player>[]) List<Player> players,
    @Default(0) int leaderIndex,
    @Default(0) int revealIndex,
    @Default(<int>[]) List<int> proposedTeam,
    @Default(0) int rejectStreak,
    @Default(<bool>[]) List<bool> missionVotes,
    @Default(0) int goodScore,
    @Default(0) int evilScore,
    @Default(<bool>[]) List<bool> missionHistory, // ← 先前已加入的歷史結果

    // ─────────────────────────────── 湖中女神相關 ───────────────────────────────
    @Default(true) bool ladyEnabled,              // ★ 新增：是否啟用湖中女神
    @Default(-1) int ladyHolderIndex,             // 持有人
    int? ladyTargetIndex,                         // 被查核的玩家索引

    // ─────────────────────────────── 刺殺相關 ────────────────────────────────
    int? assassinationTargetIndex,
    @Default(false) bool isAssassinationSuccess,
  }) = _GameState;

  factory GameState.fromJson(Map<String, dynamic> json) =>
      _$GameStateFromJson(json);
}
