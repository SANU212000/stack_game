import 'dart:math';
import 'package:flutter/material.dart';

/// Model representing a single particle in the particle system
/// Used for visual effects like confetti, sparks, and debris
class ParticleModel {
  final double x;
  final double y;
  final double velocityX;
  final double velocityY;
  final double size;
  final Color color;
  final double rotation;
  final double rotationSpeed;
  final double lifetime;
  final double maxLifetime;
  final ParticleType type;
  final double gravity;

  const ParticleModel({
    required this.x,
    required this.y,
    required this.velocityX,
    required this.velocityY,
    required this.size,
    required this.color,
    required this.rotation,
    required this.rotationSpeed,
    required this.lifetime,
    required this.maxLifetime,
    required this.type,
    this.gravity = 0.3,
  });

  /// Creates a copy with updated values
  ParticleModel copyWith({
    double? x,
    double? y,
    double? velocityX,
    double? velocityY,
    double? size,
    Color? color,
    double? rotation,
    double? rotationSpeed,
    double? lifetime,
    double? maxLifetime,
    ParticleType? type,
    double? gravity,
  }) {
    return ParticleModel(
      x: x ?? this.x,
      y: y ?? this.y,
      velocityX: velocityX ?? this.velocityX,
      velocityY: velocityY ?? this.velocityY,
      size: size ?? this.size,
      color: color ?? this.color,
      rotation: rotation ?? this.rotation,
      rotationSpeed: rotationSpeed ?? this.rotationSpeed,
      lifetime: lifetime ?? this.lifetime,
      maxLifetime: maxLifetime ?? this.maxLifetime,
      type: type ?? this.type,
      gravity: gravity ?? this.gravity,
    );
  }

  /// Check if particle is still alive
  bool get isAlive => lifetime < maxLifetime;

  /// Get opacity based on lifetime (fades out)
  double get opacity => (1 - (lifetime / maxLifetime)).clamp(0.0, 1.0);

  /// Update particle state for one frame
  ParticleModel update(double deltaTime) {
    return copyWith(
      x: x + velocityX * deltaTime,
      y: y + velocityY * deltaTime + gravity * deltaTime,
      velocityY: velocityY + gravity * deltaTime * 60,
      rotation: rotation + rotationSpeed * deltaTime,
      lifetime: lifetime + deltaTime,
    );
  }

  /// Create a confetti particle
  static ParticleModel confetti({
    required double x,
    required double y,
    required Random random,
  }) {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.pink,
      Colors.cyan,
    ];
    return ParticleModel(
      x: x,
      y: y,
      velocityX: (random.nextDouble() - 0.5) * 200,
      velocityY: -random.nextDouble() * 300 - 100,
      size: random.nextDouble() * 8 + 4,
      color: colors[random.nextInt(colors.length)],
      rotation: random.nextDouble() * 2 * pi,
      rotationSpeed: (random.nextDouble() - 0.5) * 10,
      lifetime: 0,
      maxLifetime: random.nextDouble() * 0.8 + 0.5,
      type: ParticleType.confetti,
      gravity: 0.5,
    );
  }

  /// Create a spark particle
  static ParticleModel spark({
    required double x,
    required double y,
    required Random random,
    Color? baseColor,
  }) {
    final color = baseColor ?? Colors.amber;
    return ParticleModel(
      x: x,
      y: y,
      velocityX: (random.nextDouble() - 0.5) * 150,
      velocityY: -random.nextDouble() * 200 - 50,
      size: random.nextDouble() * 4 + 2,
      color: color,
      rotation: 0,
      rotationSpeed: 0,
      lifetime: 0,
      maxLifetime: random.nextDouble() * 0.4 + 0.2,
      type: ParticleType.spark,
      gravity: 0.4,
    );
  }

  /// Create a debris/falling piece particle
  static ParticleModel debris({
    required double x,
    required double y,
    required double width,
    required Color color,
    required Random random,
    required bool goingRight,
  }) {
    return ParticleModel(
      x: x,
      y: y,
      velocityX: goingRight ? random.nextDouble() * 100 + 50 : -(random.nextDouble() * 100 + 50),
      velocityY: random.nextDouble() * 50,
      size: width,
      color: color,
      rotation: 0,
      rotationSpeed: (random.nextDouble() - 0.5) * 5,
      lifetime: 0,
      maxLifetime: 1.5,
      type: ParticleType.debris,
      gravity: 0.8,
    );
  }

  /// Create a star/glow particle for perfect landing
  static ParticleModel star({
    required double x,
    required double y,
    required Random random,
  }) {
    return ParticleModel(
      x: x,
      y: y,
      velocityX: (random.nextDouble() - 0.5) * 100,
      velocityY: -random.nextDouble() * 150 - 50,
      size: random.nextDouble() * 12 + 6,
      color: Colors.amber.withAlpha(200),
      rotation: random.nextDouble() * 2 * pi,
      rotationSpeed: (random.nextDouble() - 0.5) * 3,
      lifetime: 0,
      maxLifetime: random.nextDouble() * 0.6 + 0.4,
      type: ParticleType.star,
      gravity: 0.1,
    );
  }
}

/// Types of particles for different visual effects
enum ParticleType {
  confetti,   // Colorful celebration pieces
  spark,      // Small bright particles
  debris,     // Falling block pieces
  star,       // Glowing star shapes for perfect landings
}
