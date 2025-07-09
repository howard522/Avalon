// lib/models/role_converter.dart
import 'package:json_annotation/json_annotation.dart';
import 'role.dart';

/// 把 Role <–> String 的對映，自行定義要怎麼叫
class RoleConverter implements JsonConverter<Role, String> {
  const RoleConverter();

  @override
  Role fromJson(String json) {
    switch (json) {
      case 'merlin':
        return const Role.merlin();
      case 'percival':
        return const Role.percival();
      case 'loyalServant':
        return const Role.loyalServant();
      case 'assassin':
        return const Role.assassin();
      case 'morgana':
        return const Role.morgana();
      case 'mordred':
        return const Role.mordred();
      case 'oberon':
        return const Role.oberon();
      case 'minion':
        return const Role.minion();
      default:
        throw ArgumentError('Unknown role: $json');
    }
  }

  @override
  String toJson(Role role) => role.map(
        merlin: (_) => 'merlin',
        percival: (_) => 'percival',
        loyalServant: (_) => 'loyalServant',
        assassin: (_) => 'assassin',
        morgana: (_) => 'morgana',
        mordred: (_) => 'mordred',
        oberon: (_) => 'oberon',
        minion: (_) => 'minion',
      );
}
