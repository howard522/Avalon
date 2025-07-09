// lib/models/player.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'role.dart';
import 'role_converter.dart';

part 'player.freezed.dart';
part 'player.g.dart';

@freezed
abstract class Player with _$Player {
  const factory Player({
    required String name,
    @RoleConverter() required Role role,
  }) = _Player;

  factory Player.fromJson(Map<String, dynamic> json) =>
      _$PlayerFromJson(json);
}
// The Player class represents a player in the game Avalon.
// It has a name and a role, which is converted using the RoleConverter.