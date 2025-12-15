import '../../../core/constants/app_constants.dart';

/// Model for animation configuration and state
class AnimationModel {
  final double movementSpeed; // Pixels per frame
  final int dropDuration; // Milliseconds
  final int trimDuration; // Milliseconds
  final bool isAnimating; // Whether any animation is in progress

  const AnimationModel({
    this.movementSpeed = AppConstants.blockSpeed,
    this.dropDuration = AppConstants.dropAnimationDuration,
    this.trimDuration = AppConstants.trimAnimationDuration,
    this.isAnimating = false,
  });

  /// Creates a copy with updated values
  AnimationModel copyWith({
    double? movementSpeed,
    int? dropDuration,
    int? trimDuration,
    bool? isAnimating,
  }) {
    return AnimationModel(
      movementSpeed: movementSpeed ?? this.movementSpeed,
      dropDuration: dropDuration ?? this.dropDuration,
      trimDuration: trimDuration ?? this.trimDuration,
      isAnimating: isAnimating ?? this.isAnimating,
    );
  }
}

