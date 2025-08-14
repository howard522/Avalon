// lib/widgets/app_background.dart
import 'package:flutter/material.dart';

/// 全域背景：統一使用 wood_plank_full.png；若資源缺失則以漸層降級。
class AppBackground extends StatelessWidget {
  final Widget child;
  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    const bgAsset = 'assets/images/textures/wood_plank_full.png';

    return Stack(
      fit: StackFit.expand,
      children: [
        // 背景圖
        Image.asset(
          bgAsset,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          filterQuality: FilterQuality.low,
          errorBuilder: (_, __, ___) {
            // 安全降級：避免白屏
            return const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF5C4033), Color(0xFF3E2C1C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            );
          },
        ),
        // 輕微暗角，讓內容聚焦
        IgnorePointer(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [Colors.black.withOpacity(0.25), Colors.transparent],
                radius: 1.0,
                center: Alignment.center,
              ),
            ),
          ),
        ),
        // 內容
        child,
      ],
    );
  }
}
