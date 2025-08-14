// lib/widgets/wood_plaque_button.dart
import 'package:flutter/material.dart';

/// 通用木牌按鈕：以 ProposalPage 的木牌風格統一 CTA。
class WoodPlaqueButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback? onTap;
  final double? height;
  final EdgeInsetsGeometry? margin;

  const WoodPlaqueButton({
    super.key,
    required this.label,
    this.enabled = true,
    this.onTap,
    this.height,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final image = AssetImage(
      enabled
          ? 'assets/images/plaques/wood_plaque_light.png'
          : 'assets/images/plaques/wood_plaque_dark.png',
    );

    final button = Container(
      height: height ?? 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        image: DecorationImage(image: image, fit: BoxFit.fill),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'MedievalSharp',
          fontSize: 20,
          color: enabled ? Colors.black87 : Colors.white70,
          letterSpacing: 1.1,
        ),
      ),
    );

    if (!enabled) {
      return Opacity(opacity: .6, child: Padding(padding: margin ?? EdgeInsets.zero, child: button));
    }

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: GestureDetector(
        onTap: onTap,
        child: button,
      ),
    );
  }
}
