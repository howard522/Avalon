// lib/models/game_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'player.dart';

part 'game_state.freezed.dart';
part 'game_state.g.dart';

/// 遊戲所處階段
enum GamePhase { setup, reveal, proposal, voting, quest, assassinate, result }

@freezed
abstract class GameState with _$GameState {
  const factory GameState({
    @Default(GamePhase.setup) GamePhase phase,
    @Default(<Player>[]) List<Player> players,
    @Default(0) int leaderIndex,
    @Default(0) int revealIndex, // 新增
    @Default(0) int goodScore,
    @Default(0) int evilScore,
    @Default(0) int failedVoteStreak,
  }) = _GameState;

  factory GameState.fromJson(Map<String, dynamic> json) =>
      _$GameStateFromJson(json);
}
