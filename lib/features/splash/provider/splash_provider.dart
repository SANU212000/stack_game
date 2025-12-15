import 'package:flutter/material.dart';

/// Provider to manage Space Arcade Splash Screen animations
class SplashProvider extends ChangeNotifier {
  // Controllers
  late AnimationController
  _mainController; // Controls visual entrance (Planet/Text)
  late AnimationController _rocketController; // Controls rocket hover/fly
  late AnimationController _loadingController; // Controls progress bar

  // Animations
  late Animation<double> _planetScaleAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<Offset> _rocketHoverAnimation;
  late Animation<double> _rocketFlameAnimation;
  late Animation<double> _loadingProgressAnimation;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Animation<double> get planetScaleAnimation => _planetScaleAnimation;
  Animation<double> get textOpacityAnimation => _textOpacityAnimation;
  Animation<Offset> get rocketHoverAnimation => _rocketHoverAnimation;
  Animation<double> get rocketFlameAnimation => _rocketFlameAnimation;
  Animation<double> get loadingProgressAnimation => _loadingProgressAnimation;

  void setControllers({
    required AnimationController main,
    required AnimationController rocket,
    required AnimationController loading,
  }) {
    _mainController = main;
    _rocketController = rocket;
    _loadingController = loading;

    // 1. Entrance & Planet Scale
    _planetScaleAnimation = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    );

    _textOpacityAnimation = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.4, 0.8, curve: Curves.easeIn),
    );

    // 2. Rocket Hover & Flame (Looping)
    _rocketHoverAnimation =
        Tween<Offset>(
          begin: const Offset(0, 0),
          end: const Offset(0, -0.05), // Subtle float up/down
        ).animate(
          CurvedAnimation(parent: _rocketController, curve: Curves.easeInOut),
        );

    _rocketFlameAnimation = CurvedAnimation(
      parent: _rocketController,
      curve: Curves.easeInOut,
    );

    // 3. Loading Progress
    _loadingProgressAnimation = CurvedAnimation(
      parent: _loadingController,
      curve: Curves.easeInOutCubic,
    );

    _isInitialized = true;
  }

  void startAnimation(VoidCallback onComplete) {
    if (!_isInitialized) return;

    _mainController.forward();
    _rocketController.repeat(reverse: true);
    _loadingController.forward();

    // Navigate after loading finishes
    Future.delayed(const Duration(milliseconds: 3000), () {
      onComplete();
    });
  }

  void cleanup() {
    _isInitialized = false;
    // We do not dispose controllers here as they are owned by the view
  }

}
