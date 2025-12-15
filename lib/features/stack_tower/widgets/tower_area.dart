import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../model/block_model.dart';
import '../model/particle_model.dart';
import '../../../core/constants/app_colors.dart';

/// Enhanced custom painter for the tower area
/// Renders blocks with gradients, particles, and visual effects
class TowerAreaPainter extends CustomPainter {
  final List<BlockModel> placedBlocks;
  final BlockModel? currentBlock;
  final List<ParticleModel> particles;
  final int level;
  final int combo;

  final AppColorProvider colors;

  TowerAreaPainter({
    required this.placedBlocks,
    required this.colors,
    this.currentBlock,
    this.particles = const [],
    this.level = 1,
    this.combo = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw animated gradient background
    _drawBackground(canvas, size);

    // Draw grid lines for depth effect
    _drawGridLines(canvas, size);

    // Draw guide line for block placement
    if (currentBlock != null && placedBlocks.isNotEmpty) {
      _drawGuideLine(canvas, size);
    }

    // Draw placed blocks with enhanced styling
    for (final block in placedBlocks) {
      _drawEnhancedBlock(canvas, block, false);
    }

    // Draw current moving block with glow
    if (currentBlock != null) {
      _drawEnhancedBlock(canvas, currentBlock!, true);
    }

    // Draw particles on top
    for (final particle in particles) {
      _drawParticle(canvas, particle);
    }
  }

  void _drawBackground(Canvas canvas, Size size) {
    // Dynamic gradient based on level
    final colors = _getBackgroundColors();

    final backgroundPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: colors,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      backgroundPaint,
    );
  }

  List<Color> _getBackgroundColors() {
    // Dynamic gradient from AppColors based on level
    final index = (level % (colors.levelThemes.length));
    return colors.levelThemes[index == 0
        ? 0
        : index - 1]; // Handle 1-based level vs 0-based index
  }

  void _drawGridLines(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = colors.textPrimary.withAlpha(15)
      ..strokeWidth = 1;

    // Vertical lines
    for (double x = 0; x <= size.width; x += 50) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    // Horizontal lines
    for (double y = 0; y <= size.height; y += 50) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  void _drawGuideLine(Canvas canvas, Size size) {
    if (placedBlocks.isEmpty || currentBlock == null) return;

    final lastBlock = placedBlocks.last;
    final guideRect = Rect.fromLTWH(
      lastBlock.left,
      0,
      lastBlock.width,
      lastBlock.y,
    );

    final guidePaint = Paint()
      ..color = colors.textPrimary.withAlpha(30)
      ..style = PaintingStyle.fill;

    canvas.drawRect(guideRect, guidePaint);

    // Draw edge lines
    final edgePaint = Paint()
      ..color = colors.textPrimary.withAlpha(60)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(lastBlock.left, 0),
      Offset(lastBlock.left, lastBlock.y),
      edgePaint,
    );
    canvas.drawLine(
      Offset(lastBlock.right, 0),
      Offset(lastBlock.right, lastBlock.y),
      edgePaint,
    );
  }

  void _drawEnhancedBlock(Canvas canvas, BlockModel block, bool isCurrent) {
    final rect = Rect.fromLTWH(block.left, block.y, block.width, block.height);

    // Create gradient based on block color
    final baseColor =
        colors.blockColors[block.colorIndex % colors.blockColors.length];
    final lighterColor = Color.lerp(baseColor, colors.textPrimary, 0.3)!;
    final darkerColor = Color.lerp(baseColor, Colors.black, 0.3)!;

    // Main block gradient
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [lighterColor, baseColor, darkerColor],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(rect);

    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(6));

    // Draw glow for current block or combo blocks
    if (isCurrent || combo >= 3) {
      final glowPaint = Paint()
        ..color = (isCurrent ? colors.textPrimary : colors.accent).withAlpha(60)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

      canvas.drawRRect(
        RRect.fromRectAndRadius(rect.inflate(5), const Radius.circular(8)),
        glowPaint,
      );
    }

    // Draw shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withAlpha(80)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect.translate(0, 4), const Radius.circular(6)),
      shadowPaint,
    );

    // Draw main block
    canvas.drawRRect(rrect, gradientPaint);

    // Draw highlight (top edge shine)
    final highlightRect = Rect.fromLTWH(
      block.left + 4,
      block.y + 2,
      block.width - 8,
      4,
    );
    final highlightPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          colors.textPrimary.withAlpha(100),
          colors.textPrimary.withAlpha(0),
        ],
      ).createShader(highlightRect);

    canvas.drawRRect(
      RRect.fromRectAndRadius(highlightRect, const Radius.circular(2)),
      highlightPaint,
    );

    // Draw border
    final borderPaint = Paint()
      ..color = isCurrent
          ? colors.textPrimary.withAlpha(200)
          : colors.textPrimary.withAlpha(60)
      ..style = PaintingStyle.stroke
      ..strokeWidth = isCurrent ? 2 : 1;

    canvas.drawRRect(rrect, borderPaint);

    // Draw 3D side effect
    final sidePaint = Paint()..color = darkerColor.withAlpha(150);

    final sidePath = Path()
      ..moveTo(block.left, block.bottom - 6)
      ..lineTo(block.left + 3, block.bottom + 2)
      ..lineTo(block.right - 3, block.bottom + 2)
      ..lineTo(block.right, block.bottom - 6)
      ..close();

    canvas.drawPath(sidePath, sidePaint);
  }

  void _drawParticle(Canvas canvas, ParticleModel particle) {
    final paint = Paint()
      ..color = particle.color.withAlpha((particle.opacity * 255).toInt());

    switch (particle.type) {
      case ParticleType.confetti:
        _drawConfetti(canvas, particle, paint);
        break;
      case ParticleType.spark:
        _drawSpark(canvas, particle, paint);
        break;
      case ParticleType.debris:
        _drawDebris(canvas, particle, paint);
        break;
      case ParticleType.star:
        _drawStar(canvas, particle, paint);
        break;
    }
  }

  void _drawConfetti(Canvas canvas, ParticleModel particle, Paint paint) {
    canvas.save();
    canvas.translate(particle.x, particle.y);
    canvas.rotate(particle.rotation);

    canvas.drawRect(
      Rect.fromCenter(
        center: Offset.zero,
        width: particle.size,
        height: particle.size / 2,
      ),
      paint,
    );

    canvas.restore();
  }

  void _drawSpark(Canvas canvas, ParticleModel particle, Paint paint) {
    paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawCircle(Offset(particle.x, particle.y), particle.size, paint);
  }

  void _drawDebris(Canvas canvas, ParticleModel particle, Paint paint) {
    canvas.save();
    canvas.translate(particle.x, particle.y);
    canvas.rotate(particle.rotation);

    final rect = Rect.fromCenter(
      center: Offset.zero,
      width: particle.size,
      height: AppConstants.initialBlockHeight * 0.8,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(3)),
      paint,
    );

    canvas.restore();
  }

  void _drawStar(Canvas canvas, ParticleModel particle, Paint paint) {
    paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    canvas.save();
    canvas.translate(particle.x, particle.y);
    canvas.rotate(particle.rotation);

    // Draw star shape
    final path = _createStarPath(particle.size);
    canvas.drawPath(path, paint);

    // Draw bright center
    paint.color = colors.textPrimary.withAlpha(
      (particle.opacity * 200).toInt(),
    );
    canvas.drawCircle(Offset.zero, particle.size * 0.3, paint);

    canvas.restore();
  }

  Path _createStarPath(double size) {
    final path = Path();
    final numPoints = 5;
    final outerRadius = size;
    final innerRadius = size * 0.4;

    for (int i = 0; i < numPoints * 2; i++) {
      final radius = i.isEven ? outerRadius : innerRadius;
      final angle = (i * pi / numPoints) - pi / 2;
      final x = radius * cos(angle);
      final y = radius * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    return path;
  }

  @override
  bool shouldRepaint(TowerAreaPainter oldDelegate) {
    return oldDelegate.placedBlocks.length != placedBlocks.length ||
        oldDelegate.currentBlock != currentBlock ||
        oldDelegate.particles.length != particles.length ||
        oldDelegate.level != level ||
        oldDelegate.combo != combo ||
        (currentBlock != null &&
            oldDelegate.currentBlock?.x != currentBlock?.x);
  }
}

/// Widget containing the tower area with enhanced visuals
class TowerArea extends StatelessWidget {
  final List<BlockModel> placedBlocks;
  final BlockModel? currentBlock;
  final List<ParticleModel> particles;
  final int level;
  final int combo;
  final VoidCallback onTap;

  const TowerArea({
    super.key,
    required this.placedBlocks,
    this.currentBlock,
    this.particles = const [],
    this.level = 1,
    this.combo = 0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: AppConstants.towerAreaWidth,
          height: AppConstants.towerAreaHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(100),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CustomPaint(
              painter: TowerAreaPainter(
                placedBlocks: placedBlocks,
                currentBlock: currentBlock,
                particles: particles,
                level: level,
                combo: combo,
                colors: context.watch<AppColorProvider>(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
