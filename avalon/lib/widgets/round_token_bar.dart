import 'package:flutter/material.dart';
import '../models/team_size_factory.dart';

enum _RoundStatus { success, fail, pending }

class RoundTokenBar extends StatelessWidget {
  const RoundTokenBar({
    super.key,
    required this.playerCount,
    required this.missionHistory, // 已完成回合：true=成功 / false=失敗
  });

  final int playerCount;
  final List<bool> missionHistory;

  @override
  Widget build(BuildContext context) {
    // 5 回合需要人數
    final teamSizes =
        List.generate(5, (i) => TeamSizeFactory.teamSize(playerCount, i + 1));

    return Row(
      children: List.generate(5, (i) {
        final status = i < missionHistory.length
            ? (missionHistory[i] ? _RoundStatus.success : _RoundStatus.fail)
            : _RoundStatus.pending;

        final size = teamSizes[i];
        final asset = _assetFor(status, size);

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Image.asset(asset, fit: BoxFit.contain),
          ),
        );
      }),
    );
  }

  String _assetFor(_RoundStatus s, int teamSize) {
    final color = switch (s) {
      _RoundStatus.success => 'green',
      _RoundStatus.fail => 'red',
      _RoundStatus.pending => 'grey',
    };
    return 'assets/images/round_tokens/${color}_$teamSize.png';
  }
}
