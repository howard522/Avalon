// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GameState _$GameStateFromJson(Map<String, dynamic> json) => _GameState(
  phase:
      $enumDecodeNullable(_$GamePhaseEnumMap, json['phase']) ?? GamePhase.setup,
  players:
      (json['players'] as List<dynamic>?)
          ?.map((e) => Player.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Player>[],
  leaderIndex: (json['leaderIndex'] as num?)?.toInt() ?? 0,
  revealIndex: (json['revealIndex'] as num?)?.toInt() ?? 0,
  proposedTeam:
      (json['proposedTeam'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const <int>[],
  rejectStreak: (json['rejectStreak'] as num?)?.toInt() ?? 0,
  missionVotes:
      (json['missionVotes'] as List<dynamic>?)
          ?.map((e) => e as bool)
          .toList() ??
      const <bool>[],
  goodScore: (json['goodScore'] as num?)?.toInt() ?? 0,
  evilScore: (json['evilScore'] as num?)?.toInt() ?? 0,
  ladyHolderIndex: (json['ladyHolderIndex'] as num?)?.toInt() ?? -1,
  ladyTargetIndex: (json['ladyTargetIndex'] as num?)?.toInt(),
  assassinationTargetIndex: (json['assassinationTargetIndex'] as num?)?.toInt(),
  isAssassinationSuccess: json['isAssassinationSuccess'] as bool? ?? false,
);

Map<String, dynamic> _$GameStateToJson(_GameState instance) =>
    <String, dynamic>{
      'phase': _$GamePhaseEnumMap[instance.phase]!,
      'players': instance.players,
      'leaderIndex': instance.leaderIndex,
      'revealIndex': instance.revealIndex,
      'proposedTeam': instance.proposedTeam,
      'rejectStreak': instance.rejectStreak,
      'missionVotes': instance.missionVotes,
      'goodScore': instance.goodScore,
      'evilScore': instance.evilScore,
      'ladyHolderIndex': instance.ladyHolderIndex,
      'ladyTargetIndex': instance.ladyTargetIndex,
      'assassinationTargetIndex': instance.assassinationTargetIndex,
      'isAssassinationSuccess': instance.isAssassinationSuccess,
    };

const _$GamePhaseEnumMap = {
  GamePhase.setup: 'setup',
  GamePhase.reveal: 'reveal',
  GamePhase.proposal: 'proposal',
  GamePhase.vote: 'vote',
  GamePhase.quest: 'quest',
  GamePhase.lady: 'lady',
  GamePhase.assassinate: 'assassinate',
  GamePhase.result: 'result',
};
