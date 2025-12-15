import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Draws the cartoon Planet with a ring
class PlanetPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint = Paint()..style = PaintingStyle.fill;

    // 1. Planet Body (Purple Gradient)
    final planetGradient = RadialGradient(
      colors: [
        const Color(0xFF9C27B0), // Purple 500
        const Color(0xFF4A148C), // Purple 900
      ],
      center: Alignment.topLeft,
      radius: 1.2,
    );

    paint.shader = planetGradient.createShader(
      Rect.fromCircle(center: center, radius: radius),
    );
    canvas.drawCircle(center, radius, paint);

    // 2. Craters (Darker spots)
    paint.shader = null;
    paint.color = Colors.black.withAlpha(0x33);

    canvas.drawCircle(
      center + Offset(-radius * 0.4, -radius * 0.3),
      radius * 0.25,
      paint,
    );
    canvas.drawCircle(
      center + Offset(radius * 0.5, radius * 0.2),
      radius * 0.15,
      paint,
    );
    canvas.drawCircle(
      center + Offset(-radius * 0.2, radius * 0.6),
      radius * 0.1,
      paint,
    );

    // 3. Ring (Behind part) -> Doing full ring for simplicity, masked by depth would be complex
    // Simulating ring with an oval path
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12.0
      ..color = const Color(0xFF26C6DA).withAlpha(0x33); // Cyan

    final ringRect = Rect.fromCenter(
      center: center,
      width: size.width * 1.6,
      height: size.height * 0.5,
    );

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-math.pi / 6); // Tilt
    canvas.translate(-center.dx, -center.dy);
    canvas.drawOval(ringRect, ringPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Draws a cartoon Rocket Ship
class RocketPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Coordinate space: (0,0) is top-left
    final w = size.width;
    final h = size.height;

    final bodyPaint = Paint()..color = const Color(0xFFE57373); // Red-ish body
    final windowPaint = Paint()
      ..color = const Color(0xFF4DD0E1); // Clean blue glass
    final finPaint = Paint()..color = const Color(0xFFB71C1C); // Dark red fins
    final steelPaint = Paint()
      ..color = const Color(0xFF607D8B); // Grey nose/engine

    // Fins
    final path = Path();
    path.moveTo(w * 0.5, 0); // Nose tip

    // Left Fin
    final leftFin = Path();
    leftFin.moveTo(w * 0.3, h * 0.7);
    leftFin.lineTo(0, h);
    leftFin.lineTo(w * 0.3, h * 0.9);
    leftFin.close();
    canvas.drawPath(leftFin, finPaint);

    // Right Fin
    final rightFin = Path();
    rightFin.moveTo(w * 0.7, h * 0.7);
    rightFin.lineTo(w, h);
    rightFin.lineTo(w * 0.7, h * 0.9);
    rightFin.close();
    canvas.drawPath(rightFin, finPaint);

    // Main Body (Fuselage)
    final bodyRect = RRect.fromLTRBR(
      w * 0.25,
      h * 0.15,
      w * 0.75,
      h * 0.9,
      const Radius.circular(20),
    );
    canvas.drawRRect(bodyRect, bodyPaint);

    // Nose Cone
    final nosePath = Path();
    nosePath.moveTo(w * 0.25, h * 0.2); // Start left
    nosePath.quadraticBezierTo(
      w * 0.5,
      -h * 0.1,
      w * 0.75,
      h * 0.2,
    ); // Curve to tip
    nosePath.lineTo(w * 0.75, h * 0.2);
    nosePath.lineTo(w * 0.25, h * 0.2);
    nosePath.close();
    canvas.drawPath(nosePath, steelPaint);

    // Window
    canvas.drawCircle(Offset(w * 0.5, h * 0.45), w * 0.15, windowPaint);
    // Window Rim
    canvas.drawCircle(
      Offset(w * 0.5, h * 0.45),
      w * 0.15,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = const Color(0xFFECEFF1)
        ..strokeWidth = 3,
    );

    // Engine Exhaust
    final enginePath = Path();
    enginePath.moveTo(w * 0.35, h * 0.9);
    enginePath.lineTo(w * 0.65, h * 0.9);
    enginePath.lineTo(w * 0.6, h * 0.95);
    enginePath.lineTo(w * 0.4, h * 0.95);
    enginePath.close();
    canvas.drawPath(enginePath, steelPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Draws the Flame trail
class FlamePainter extends CustomPainter {
  final double flicker; // 0.0 to 1.0

  FlamePainter({required this.flicker});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final paint = Paint()..style = PaintingStyle.fill;

    // Core (Yellow)
    paint.color = const Color(0xFFFFEB3B);
    final corePath = Path();
    corePath.moveTo(w * 0.3, 0);
    corePath.lineTo(w * 0.7, 0);
    corePath.lineTo(w * 0.5, h * (0.6 + flicker * 0.2)); // Flicker length
    corePath.close();
    canvas.drawPath(corePath, paint);

    // Outer (Orange)
    paint.color = const Color(0xFFFF9800).withAlpha(0x33);
    final outerPath = Path();
    outerPath.moveTo(w * 0.2, 0);
    outerPath.lineTo(w * 0.8, 0);
    outerPath.lineTo(w * 0.5, h * (0.8 + flicker * 0.2));
    outerPath.close();
    canvas.drawPath(outerPath, paint);
  }

  @override
  bool shouldRepaint(covariant FlamePainter oldDelegate) =>
      oldDelegate.flicker != flicker;
}
