// lib/models/role_factory.dart

import 'role.dart';

/// 根據玩家人數回傳對應角色陣容（不含洗牌）
class RoleFactory {
  static List<Role> rolesForCount(int count) {
    switch (count) {
      case 5:
        return [
          const Role.merlin(),
          const Role.percival(),
          const Role.loyalServant(),
          const Role.morgana(),
          const Role.assassin(),
        ];
      case 6:
        return [
          const Role.merlin(),
          const Role.percival(),
          const Role.loyalServant(),
          const Role.loyalServant(),
          const Role.morgana(),
          const Role.assassin(),
        ];
      case 7:
        return [
          const Role.merlin(),
          const Role.percival(),
          const Role.loyalServant(),
          const Role.loyalServant(),
          const Role.morgana(),
          const Role.assassin(),
          const Role.oberon(),
        ];
      case 8:
        return [
          const Role.merlin(),
          const Role.percival(),
          const Role.loyalServant(),
          const Role.loyalServant(),
          const Role.loyalServant(),
          const Role.morgana(),
          const Role.assassin(),
          const Role.minion(),
        ];
      case 9:
        return [
          const Role.merlin(),
          const Role.percival(),
          const Role.loyalServant(),
          const Role.loyalServant(),
          const Role.loyalServant(),
          const Role.loyalServant(),
          const Role.morgana(),
          const Role.assassin(),
          const Role.mordred(),
        ];
      case 10:
        return [
          const Role.merlin(),
          const Role.percival(),
          const Role.loyalServant(),
          const Role.loyalServant(),
          const Role.loyalServant(),
          const Role.loyalServant(),
          const Role.morgana(),
          const Role.assassin(),
          const Role.oberon(),
          const Role.mordred(),
        ];
      default:
        throw ArgumentError('Unsupported player count: $count');
    }
  }
}
