import 'package:freezed_annotation/freezed_annotation.dart';

part 'role.freezed.dart';

/// 好／壞陣營
enum Faction { good, evil }

@freezed
sealed class Role with _$Role {
  const Role._(); // 為自訂 getter 需要私有建構子

  /* ---------- Good ---------- */
  const factory Role.merlin() = Merlin;
  const factory Role.percival() = Percival;
  const factory Role.loyalServant() = LoyalServant;

  /* ---------- Evil ---------- */
  const factory Role.assassin() = Assassin;
  const factory Role.morgana() = Morgana;
  const factory Role.mordred() = Mordred;
  const factory Role.oberon() = Oberon;
  const factory Role.minion() = Minion;

  /// 陣營判定
  Faction get faction => when(
        merlin: () => Faction.good,
        percival: () => Faction.good,
        loyalServant: () => Faction.good,
        assassin: () => Faction.evil,
        morgana: () => Faction.evil,
        mordred: () => Faction.evil,
        oberon: () => Faction.evil,
        minion: () => Faction.evil,
      );

  /// 顯示名稱
  String get name => map(
        merlin: (_) => '梅林',
        percival: (_) => '派西維爾',
        loyalServant: (_) => '平民',
        assassin: (_) => '刺客',
        morgana: (_) => '莫干娜',
        mordred: (_) => '莫德雷德',
        oberon: (_) => '奧伯倫',
        minion: (_) => '爪牙',
      );
}
