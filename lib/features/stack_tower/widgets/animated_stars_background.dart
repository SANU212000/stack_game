import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';

/// Animated shooting stars background widget
class AnimatedStarsBackground extends StatefulWidget {
  final Widget child;

  const AnimatedStarsBackground({super.key, required this.child});

  @override
  State<AnimatedStarsBackground> createState() =>
      _AnimatedStarsBackgroundState();
}

class _AnimatedStarsBackgroundState extends State<AnimatedStarsBackground>
    with TickerProviderStateMixin {
  late AnimationController _starsController;
  late AnimationController _gradientController;
  late Animation<double> _gradientAnimation;
  final List<_Star> _stars = [];
  final List<_ShootingStar> _shootingStars = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    // Stars twinkle animation
    _starsController = AnimationController(
      duration: const Duration(milliseconds: 50),
      vsync: this,
    )..repeat();

    _starsController.addListener(() {
      _updateStars();
      _updateShootingStars();
    });

    // Background gradient animation
    _gradientController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);

    _gradientAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _gradientController, curve: Curves.easeInOut),
    );

    // Initialize stars after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeStars();
    });
  }

  void _initializeStars() {
    final size = MediaQuery.of(context).size;
    _stars.clear();

    // Create 100 static twinkling stars
    for (int i = 0; i < 100; i++) {
      _stars.add(
        _Star(
          x: _random.nextDouble() * size.width,
          y: _random.nextDouble() * size.height,
          size: _random.nextDouble() * 2 + 0.5,
          opacity: _random.nextDouble(),
          twinkleSpeed: _random.nextDouble() * 0.05 + 0.01,
        ),
      );
    }

    setState(() {});
  }

  void _updateStars() {
    // Twinkle effect
    for (var star in _stars) {
      star.opacity += star.increasing ? star.twinkleSpeed : -star.twinkleSpeed;
      if (star.opacity >= 1.0) {
        star.opacity = 1.0;
        star.increasing = false;
      } else if (star.opacity <= 0.2) {
        star.opacity = 0.2;
        star.increasing = true;
      }
    }

    // Occasionally spawn shooting stars
    if (_random.nextDouble() < 0.01 && _shootingStars.length < 3) {
      final size = MediaQuery.of(context).size;
      _shootingStars.add(
        _ShootingStar(
          x: _random.nextDouble() * size.width,
          y: _random.nextDouble() * size.height * 0.3,
          length: _random.nextDouble() * 80 + 40,
          speed: _random.nextDouble() * 15 + 10,
          angle: _random.nextDouble() * 0.5 + 0.3, // Diagonal angle
        ),
      );
    }

    if (mounted) setState(() {});
  }

  void _updateShootingStars() {
    final size = MediaQuery.of(context).size;

    for (var star in _shootingStars) {
      star.x += star.speed * cos(star.angle);
      star.y += star.speed * sin(star.angle);
      star.opacity -= 0.01;
    }

    // Remove stars that are off screen or faded
    _shootingStars.removeWhere(
      (star) =>
          star.x > size.width + 100 ||
          star.y > size.height + 100 ||
          star.opacity <= 0,
    );
  }

  @override
  void dispose() {
    _starsController.dispose();
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<AppColorProvider>();
    return AnimatedBuilder(
      animation: _gradientAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.lerp(
                  colors.animatedBackgrounds[0][0],
                  colors.animatedBackgrounds[0][1],
                  _gradientAnimation.value,
                )!,
                Color.lerp(
                  colors.animatedBackgrounds[1][0],
                  colors.animatedBackgrounds[1][1],
                  _gradientAnimation.value,
                )!,
                Color.lerp(
                  colors.animatedBackgrounds[2][0],
                  colors.animatedBackgrounds[2][1],
                  _gradientAnimation.value,
                )!,
              ],
            ),
          ),
          child: CustomPaint(
            painter: _StarsPainter(
              stars: _stars,
              shootingStars: _shootingStars,
              colors: colors,
            ),
            child: widget.child,
          ),
        );
      },
    );
  }
}

class _Star {
  double x;
  double y;
  double size;
  double opacity;
  double twinkleSpeed;
  bool increasing;

  _Star({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
    required this.twinkleSpeed,
  }) : increasing = true;
}

class _ShootingStar {
  double x;
  double y;
  double length;
  double speed;
  double angle;
  double opacity;

  _ShootingStar({
    required this.x,
    required this.y,
    required this.length,
    required this.speed,
    required this.angle,
  }) : opacity = 1.0;
}

class _StarsPainter extends CustomPainter {
  final List<_Star> stars;
  final List<_ShootingStar> shootingStars;
  final AppColorProvider colors;

  _StarsPainter({
    required this.stars,
    required this.shootingStars,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw twinkling stars
    for (var star in stars) {
      final paint = Paint()
        ..color = colors.textPrimary.withAlpha((star.opacity * 255).toInt())
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(star.x, star.y), star.size, paint);

      // Add glow to brighter stars
      if (star.opacity > 0.7) {
        final glowPaint = Paint()
          ..color = colors.textPrimary.withAlpha((star.opacity * 50).toInt())
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
        canvas.drawCircle(Offset(star.x, star.y), star.size * 2, glowPaint);
      }
    }

    // Draw shooting stars
    for (var star in shootingStars) {
      final tailEndX = star.x - star.length * cos(star.angle);
      final tailEndY = star.y - star.length * sin(star.angle);

      // Gradient tail
      final gradient = LinearGradient(
        colors: [
          colors.textPrimary.withAlpha((star.opacity * 255).toInt()),
          colors.textPrimary.withAlpha(0),
        ],
      );

      final rect = Rect.fromPoints(
        Offset(star.x, star.y),
        Offset(tailEndX, tailEndY),
      );

      final paint = Paint()
        ..shader = gradient.createShader(rect)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(
        Offset(star.x, star.y),
        Offset(tailEndX, tailEndY),
        paint,
      );

      // Bright head
      final headPaint = Paint()
        ..color = colors.textPrimary.withAlpha((star.opacity * 255).toInt())
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawCircle(Offset(star.x, star.y), 3, headPaint);
    }
  }

  @override
  bool shouldRepaint(_StarsPainter oldDelegate) => true;
}
