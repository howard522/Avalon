import 'package:flutter/material.dart';

class WoodBadge extends StatelessWidget {
  final String label;
  final bool selected;
  final bool disabled;
  final VoidCallback onTap;

  const WoodBadge({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final image = AssetImage(selected
        ? 'assets/images/plaques/wood_plaque_light.png'
        : 'assets/images/plaques/wood_plaque_dark.png');

    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Opacity(
        opacity: disabled ? 0.35 : 1.0,
        child: Container(
          width: 120,
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(image: image, fit: BoxFit.fill),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 4, offset: const Offset(0, 2)),
            ],
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'MedievalSharp',
              fontSize: 16,
              color: selected ? Colors.black : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}