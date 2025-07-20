import '../models/role.dart';
import '../models/player.dart';

class RoleInfo {
  final String title;      // 角色顯示名
  final String extraInfo;  // 當前玩家可見資訊
  final String description; // 靜態描述
  const RoleInfo({
    required this.title,
    required this.extraInfo,
    required this.description,
  });
}

class RoleInfoService {
  RoleInfo build({
    required Player self,
    required List<Player> all,
  }) {
    final role = self.role;
    return RoleInfo(
      title: role.name,
      extraInfo: _buildExtra(role, self, all),
      description: _buildDescription(role),
    );
  }

  String _buildExtra(Role role, Player self, List<Player> all) {
    return role.map(
      merlin: (_) {
        final visibles = all
            .where((p) =>
                p.role.faction == Faction.evil &&
                p.role is! Mordred)
            .map((p) => p.name)
            .join(', ');
        return '你看見的壞人：$visibles';
      },
      percival: (_) {
        final candidates = all
            .where((p) => p.role is Merlin || p.role is Morgana)
            .map((p) => p.name)
            .join(', ');
        return '你看見：$candidates，其中一人是梅林';
      },
      loyalServant: (_) => '你是忠臣：無特殊能力。',
      assassin: (_) {
        final mates = _evilTeammates(self, all, excludeOberon: true);
        return mates.isEmpty ? '沒有隊友可見' : '你的隊友：$mates';
      },
      morgana: (_) {
        final mates = _evilTeammates(self, all, excludeOberon: true);
        return '你的隊友：$mates（你在帕西維爾眼中=梅林）';
      },
      mordred: (_) {
        final mates = _evilTeammates(self, all, excludeOberon: true);
        return '你的隊友：$mates（梅林看不見你）';
      },
      oberon: (_) => '你是奧伯倫：不與壞人互認，不知道隊友，但會被梅林看見。',
      minion: (_) {
        final mates = _evilTeammates(self, all, excludeOberon: true);
        return mates.isEmpty ? '沒有隊友可見' : '你的隊友：$mates';
      },
    );
  }

  String _buildDescription(Role role) {
    return role.map(
      merlin: (_) => '梅林：可見所有壞人（不含莫德雷德），需隱藏身份以免被刺殺。',
      percival: (_) => '帕西維爾：可見梅林與摩甘娜幻象，協助保護真正的梅林。',
      loyalServant: (_) => '忠臣：無特殊能力，協助好人完成任務。',
      assassin: (_) => '刺客：好人先拿 3 勝後可刺殺梅林逆轉。',
      morgana: (_) => '摩甘娜：在帕西維爾眼中假扮梅林。',
      mordred: (_) => '莫德雷德：梅林無法偵測你。',
      oberon: (_) => '奧伯倫：不參與壞人互認，資訊最少。',
      minion: (_) => '爪牙：一般壞人支援角色。',
    );
  }

  String _evilTeammates(Player self, List<Player> all,
      {bool excludeOberon = true}) {
    return all
        .where((p) =>
            p != self &&
            p.role.faction == Faction.evil &&
            (!excludeOberon || p.role is! Oberon))
        .map((p) => p.name)
        .join(', ');
  }
}
