import 'package:flutter/material.dart';

/// 基本銅色扁平按鈕（平面 Material + 背景圖）
class MedievalButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool enabled;
  const MedievalButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final bg = enabled
        ? 'assets/images/buttons/btn_primary_copper.png'
        : 'assets/images/buttons/btn_primary_copper_disabled.png';

    return GestureDetector(
      onTap: enabled ? onPressed : null,
      child: Opacity(
        opacity: enabled ? 1 : 0.4,
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(bg), fit: BoxFit.fill),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'MedievalSharp',
              fontSize: 20,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
