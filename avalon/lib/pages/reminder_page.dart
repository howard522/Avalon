import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/game_controller.dart';
import '../services/role_info_service.dart';
import '../widgets/role_identity_card.dart';

class ReminderPage extends ConsumerStatefulWidget {
  const ReminderPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends ConsumerState<ReminderPage> {
  int? _selectedIndex;
  final _roleInfoService = RoleInfoService();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('查看身份'),
        centerTitle: true,
        elevation: 0,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 240),
        child: _selectedIndex == null
            ? _buildSelectList(state.players.length, state)
            : GestureDetector(
                key: const ValueKey('card'),
                behavior: HitTestBehavior.opaque,
                onTap: () => setState(() => _selectedIndex = null),
                child: Center(
                  child: RoleIdentityCard(
                    role: state.players[_selectedIndex!].role,
                    extraInfo: _roleInfoService
                        .build(self: state.players[_selectedIndex!], all: state.players)
                        .extraInfo,
                    roleDesc: _roleInfoService
                        .build(self: state.players[_selectedIndex!], all: state.players)
                        .description,
                    bottomHint: '（點擊任意處返回）',
                    scrollable: true,
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildSelectList(int count, dynamic state) {
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
              itemCount: count,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final name = state.players[i].name;
                return ElevatedButton(
                  onPressed: () => setState(() => _selectedIndex = i),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(name, style: const TextStyle(fontSize: 18)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
