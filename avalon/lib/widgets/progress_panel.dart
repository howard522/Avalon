import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/game_controller.dart';
import '../controllers/theme_controller.dart';
import '../pages/reminder_page.dart';
import '../pages/roles_overview_page.dart';   // ★ 新增：所有角色一覽頁面

/// 在各頁面頂端顯示：回合／領隊／好人分／壞人分 + 快捷功能按鈕
class ProgressPanel extends ConsumerWidget implements PreferredSizeWidget {
  const ProgressPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameControllerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return AppBar(
      title: Text(
        '回合 ${state.goodScore + state.evilScore + 1} • 領隊: ' +
        (state.players.isNotEmpty ? state.players[state.leaderIndex].name : '-'),
      ),
      actions: [
        // 防呆：個人身分查詢
        IconButton(
          tooltip: '查看身份',
          icon: const Icon(Icons.visibility),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ReminderPage()),
            );
          },
        ),
        // 新增：所有玩家角色列表
        IconButton(
          tooltip: '所有角色一覽',
          icon: const Icon(Icons.list),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RolesOverviewPage()),
            );
          },
        ),
        // 主題切換
        IconButton(
          tooltip: '切換主題',
          icon: Icon(
            themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode,
          ),
          onPressed: () {
            ref.read(themeModeProvider.notifier).state =
                themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
          },
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(24),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            '好人 ${state.goodScore}  ▪  壞人 ${state.evilScore}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 24);
}