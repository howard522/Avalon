import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('遊戲說明')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: const [
            Text('1. 設定玩家人數並自動分配身分。'),
            SizedBox(height: 8),
            Text('2. 身分揭示：輪流查看身份卡，暗中傳閱。'),
            SizedBox(height: 8),
            Text('3. 提名隊伍：領隊選擇隊員，送審後進入任務階段。'),
            SizedBox(height: 8),
            Text('4. 任務執行：隊員秘密選擇 Success/Fail，系統統計結果。'),
            SizedBox(height: 8),
            Text('5. 刺殺階段：好人達 3 勝後，刺客選擇 Merlin。'),
            SizedBox(height: 8),
            Text('6. 結算：顯示勝利方與分數，可重置或查看說明。'),
          ],
        ),
      ),
    );
  }
}