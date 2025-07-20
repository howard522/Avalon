import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/game_controller.dart';
import '../models/role.dart';

/// 防呆：讓玩家重新查看自己的角色資訊
class ReminderPage extends ConsumerStatefulWidget {
  const ReminderPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends ConsumerState<ReminderPage> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameControllerProvider);

    String extraInfo(int idx) {
      final player = state.players[idx];
      final role = player.role;
      if (role is Oberon) {
        return '你是奧伯倫：不被其他壞人識別，不知道隊友，但會被梅林看見。';
      }
      if (role.faction == Faction.evil) {
        final mates = state.players
            .where((p) =>
                p.role.faction == Faction.evil &&
                p.role is! Oberon &&
                p != player)
            .map((p) => p.name)
            .join(', ');
        return mates.isEmpty ? '沒有隊友可見' : '你的隊友：$mates';
      }
      if (role is Merlin) {
        final visibles = state.players
            .where((p) =>
                p.role.faction == Faction.evil &&
                p.role is! Mordred)
            .map((p) => p.name)
            .join(', ');
        return '你看見的壞人：$visibles';
      }
      if (role is Percival) {
        final candidates = state.players
            .where((p) => p.role is Merlin || p.role is Morgana)
            .map((p) => p.name)
            .join(', ');
        return '你看見：$candidates，其中一人是梅林';
      }
      return '你是忠臣：無特殊能力。';
    }

    String roleDesc(Role r) => r.map(
          merlin: (_) => '梅林：可見所有壞人（不含莫德雷德），須保密身份。',
          percival: (_) => '帕西維爾：可見梅林與摩甘娜幻象，需保護梅林。',
          loyalServant: (_) => '忠臣：無特殊能力，協助好人完成任務。',
          assassin: (_) => '刺客：好人三勝後可刺殺梅林。',
          morgana: (_) => '摩甘娜：對帕西維爾呈現梅林幻象。',
          mordred: (_) => '莫德雷德：梅林無法偵測。',
          oberon: (_) => '奧伯倫：不與壞人互認，梅林仍能看見你。',
          minion: (_) => '爪牙：無特殊能力的壞人同伴。',
        );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('查看身份'),
        centerTitle: true,
        elevation: 0,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 260),
        child: _selectedIndex == null
            ? _buildSelectList(state)
            : _buildRoleCard(state, extraInfo, roleDesc),
      ),
    );
  }

  Widget _buildSelectList(dynamic state) {
    return Padding(
      key: const ValueKey('select'),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            '請交給需要確認身份的玩家，\n並點選自己的姓名：',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 24),
            Expanded(
            child: ListView.separated(
              itemCount: state.players.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final name = state.players[i].name;
                return ElevatedButton(
                  onPressed: () => setState(() => _selectedIndex = i),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    name,
                    style: const TextStyle(fontSize: 18),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleCard(
    dynamic state,
    String Function(int) extraInfo,
    String Function(Role) roleDesc,
  ) {
    final player = state.players[_selectedIndex!];
    final role = player.role;

    return GestureDetector(
      key: const ValueKey('card'),
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _selectedIndex = null),
      child: Center(
        child: SizedBox(
          width: 360,
          height: 540,
          child: Container(
            decoration: BoxDecoration(
              image: const DecorationImage(
                image:
                    AssetImage('assets/images/card_front_placeholder.png'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.18),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _RoleAvatar(role: role),
                    const SizedBox(height: 16),
                    Text(
                      role.name,
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      extraInfo(_selectedIndex!),
                      style: const TextStyle(
                        fontSize: 18,
                        height: 1.33,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      roleDesc(role),
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.3,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      '（點擊任意處返回）',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleAvatar extends StatelessWidget {
  final Role role;
  const _RoleAvatar({Key? key, required this.role}) : super(key: key);

  String _roleAsset(Role r) {
    return r.map(
      merlin: (_) => 'assets/images/role_merlin.png',
      percival: (_) => 'assets/images/role_percival.png',
      loyalServant: (_) => 'assets/images/role_loyal.png',
      assassin: (_) => 'assets/images/role_assassin.png',
      morgana: (_) => 'assets/images/role_morgana.png',
      mordred: (_) => 'assets/images/role_mordred.png',
      oberon: (_) => 'assets/images/role_oberon.png',
      minion: (_) => 'assets/images/role_minion.png',
    );
  }

  @override
  Widget build(BuildContext context) {
    final path = _roleAsset(role);
    return ClipOval(
      child: Image.asset(
        path,
        width: 120,
        height: 120,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: 120,
          height: 120,
          color: Colors.grey[300],
          alignment: Alignment.center,
          child: Text(
            role.name.characters.first.toUpperCase(),
            style: const TextStyle(
              fontSize: 44,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ),
      ),
    );
  }
}
