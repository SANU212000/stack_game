import 'dart:math';
import 'package:flutter/material.dart';

class StarBackground extends StatelessWidget {
  final Widget child;

  const StarBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Night sky gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0a0a2a), Color(0xFF1a1a4a), Color(0xFF0a0a1a)],
            ),
          ),
        ),
        // Subtle stars
        const Positioned.fill(child: StarsWidget()),
        child,
      ],
    );
  }
}

class StarsWidget extends StatelessWidget {
  const StarsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: StarsPainter());
  }
}

class StarsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(42); // Constant seed for consistent stars
    final paint = Paint()..color = Colors.white.withAlpha(150);

    for (int i = 0; i < 100; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 1.5;

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
