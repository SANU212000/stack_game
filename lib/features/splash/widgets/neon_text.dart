import 'package:flutter/material.dart';

class NeonText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final double blurRadius;
  final bool isFlickering;

  const NeonText({
    super.key,
    required this.text,
    required this.fontSize,
    required this.color,
    this.blurRadius = 10.0,
    this.isFlickering = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w900,
        color: Colors.white,
        fontFamily: 'Roboto', // Or a custom arcade font if available
        shadows: [
          // Inner glow
          Shadow(color: color, blurRadius: blurRadius / 2, offset: Offset.zero),
          // Outer glow
          Shadow(color: color, blurRadius: blurRadius, offset: Offset.zero),
          // Intense outer glow
          Shadow(
            color: color.withAlpha(0x33),
            blurRadius: blurRadius * 2,
            offset: Offset.zero,
          ),
        ],
      ),
    );
  }
}
