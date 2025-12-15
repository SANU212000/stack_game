import 'package:flutter/material.dart';

/// Extension methods for common utility functions
extension DoubleExtensions on double {
  /// Clamps a double value between min and max
  double clampBetween(double min, double max) {
    if (this < min) return min;
    if (this > max) return max;
    return this;
  }
  
  /// Checks if value is approximately equal (within tolerance)
  bool isApproximatelyEqual(double other, {double tolerance = 0.01}) {
    return (this - other).abs() < tolerance;
  }
}

extension ColorExtensions on Color {
  /// Creates a darker shade of the color
  Color darken([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
  
  /// Creates a lighter shade of the color
  Color lighten([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }
}

