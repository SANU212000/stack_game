import 'dart:math';

import '../../../core/constants/app_constants.dart';

final _random = Random();

/// Model representing a single block in the tower
/// Immutable data class following best practices
class BlockModel {
  final double x; // Horizontal position (center of block)
  final double y; // Vertical position (top of block)
  final double width;
  final double height;
  final int colorIndex; // Index for color lookup
  final int index; // Block number in the tower (0 = bottom)

  const BlockModel({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.colorIndex,
    required this.index,
  });

  /// Creates a copy with updated values
  BlockModel copyWith({
    double? x,
    double? y,
    double? width,
    double? height,
    int? colorIndex,
    int? index,
  }) {
    return BlockModel(
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      colorIndex: colorIndex ?? this.colorIndex,
      index: index ?? this.index,
    );
  }

  /// Left edge position
  double get left => x - width / 2;

  /// Right edge position
  double get right => x + width / 2;

  /// Bottom edge position
  double get bottom => y + height;

  /// Creates the initial block at the bottom of the tower
  factory BlockModel.initial() {
    return BlockModel(
      x: AppConstants.towerAreaWidth / 2, // Center horizontally
      y:
          AppConstants.towerAreaHeight -
          AppConstants.initialBlockHeight, // Bottom of tower
      width: AppConstants.initialBlockWidth,
      height: AppConstants.initialBlockHeight,
      colorIndex: 0,
      index: 0,
    );
  }

  /// Creates a new moving block at the top with random starting position
  factory BlockModel.moving({required double width, required int index}) {
    // Random starting position - either from left or right edge
    final startFromRight = _random.nextBool();
    final startX = startFromRight
        ? AppConstants.towerAreaWidth -
              width /
                  2 // Start from right
        : width / 2; // Start from left

    // Random color index between 0 and 6 (assuming 7 colors)
    // This allows theme provider to map this index to any color list
    return BlockModel(
      x: startX,
      y: 0, // Start at top
      width: width,
      height: AppConstants.initialBlockHeight,
      colorIndex: _random.nextInt(7),
      index: index,
    );
  }

  @override
  String toString() {
    return 'BlockModel(x: $x, y: $y, width: $width, height: $height, index: $index)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BlockModel &&
        other.x == x &&
        other.y == y &&
        other.width == width &&
        other.height == height &&
        other.index == index;
  }

  @override
  int get hashCode {
    return Object.hash(x, y, width, height, index);
  }
}
