import 'package:flutter/material.dart';
import '../constants/assets.dart';

class RoundScaleBar extends StatelessWidget {
  final List<int> teamSizes;        // 每回合隊伍人數表（固定 5）
  final List<bool> history;         // 已完成回合結果
  const RoundScaleBar({super.key, required this.teamSizes, required this.history});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      children: List.generate(5, (i) {
        final bool hasResult = i < history.length;
        final String img = hasResult
            ? (history[i] ? AppAssets.images.tokenSuccess : AppAssets.images.tokenFail)
            : AppAssets.images.tokenHidden;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${teamSizes[i]}人', style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            Image.asset(img, width: 32, height: 32, fit: BoxFit.contain),
          ],
        );
      }),
    );
  }
}
