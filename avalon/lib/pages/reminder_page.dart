import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/game_controller.dart';
import '../models/role.dart';
import '../widgets/progress_panel.dart';

/// 防呆：任何時候都可進入，讓玩家重新確認自己的角色與隊友
class ReminderPage extends ConsumerStatefulWidget {
  const ReminderPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends ConsumerState<ReminderPage> {
  int? _selectedIndex; // null ＝尚未選人；>=0 ＝已選定玩家索引

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameControllerProvider);

    /// 依玩家與角色類型回傳額外提示文字（與 RevealPage 相同邏輯）
    String _extraInfo(int idx) {
      final player = state.players[idx];
      final role = player.role;
      if (role is Oberon) {
        return '你是奧伯倫：不被其他壞人或梅林識別，也不知道隊友。';
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
                p.role is! Mordred &&
                p.role is! Oberon)
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

    String _roleDesc(Role r) => r.map(
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
      appBar: const ProgressPanel(),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _selectedIndex == null
            // —— 階段 1：選擇自己的名字 —— //
            ? Padding(
                key: const ValueKey('select'),
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      '請將手機交給需要查看身份的玩家，\n並點選自己的姓名：',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 24),
                    ...state.players.asMap().entries.map((e) {
                      final idx = e.key;
                      final name = e.value.name;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: ElevatedButton(
                          onPressed: () => setState(() => _selectedIndex = idx),
                          child: Text(name),
                        ),
                      );
                    }),
                  ],
                ),
              )
            // —— 階段 2：顯示身份卡 —— //
            : GestureDetector(
                key: const ValueKey('card'),
                behavior: HitTestBehavior.opaque,
                onTap: () => setState(() => _selectedIndex = null),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.players[_selectedIndex!].role.name,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _extraInfo(_selectedIndex!),
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _roleDesc(state.players[_selectedIndex!].role),
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '（點擊螢幕隱藏）',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
