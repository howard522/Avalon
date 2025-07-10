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
  missionVotes:
      (json['missionVotes'] as List<dynamic>?)
          ?.map((e) => e as bool)
          .toList() ??
      const <bool>[],
  goodScore: (json['goodScore'] as num?)?.toInt() ?? 0,
  evilScore: (json['evilScore'] as num?)?.toInt() ?? 0,
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
      'missionVotes': instance.missionVotes,
      'goodScore': instance.goodScore,
      'evilScore': instance.evilScore,
      'assassinationTargetIndex': instance.assassinationTargetIndex,
      'isAssassinationSuccess': instance.isAssassinationSuccess,
    };

const _$GamePhaseEnumMap = {
  GamePhase.setup: 'setup',
  GamePhase.reveal: 'reveal',
  GamePhase.proposal: 'proposal',
  GamePhase.quest: 'quest',
  GamePhase.assassinate: 'assassinate',
  GamePhase.result: 'result',
};
