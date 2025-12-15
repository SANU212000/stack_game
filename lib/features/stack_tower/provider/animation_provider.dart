import 'package:flutter/material.dart';

/// AnimationProvider - Manages UI animations for Stack Tower Game
///
/// Handles all animation controllers and provides them to the UI layer.
/// Created at the view level where TickerProvider is available.
class AnimationProvider extends ChangeNotifier {
  late AnimationController _bgAnimationController;
  late Animation<double> _bgAnimation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _menuController;
  late Animation<double> _menuAnimation;

  // Getters
  Animation<double> get bgAnimation => _bgAnimation;
  Animation<double> get pulseAnimation => _pulseAnimation;
  Animation<double> get menuAnimation => _menuAnimation;
  AnimationController get menuController => _menuController;

  AnimationProvider(TickerProvider vsync) {
    _initializeAnimations(vsync);
  }

  void _initializeAnimations(TickerProvider vsync) {
    // Background gradient animation
    _bgAnimationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: vsync,
    )..repeat(reverse: true);

    _bgAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bgAnimationController, curve: Curves.easeInOut),
    );

    // Pulse animation for start button
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: vsync,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Menu Animation
    _menuController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: vsync,
    );

    _menuAnimation = CurvedAnimation(
      parent: _menuController,
      curve: Curves.easeInOutQuart,
    );
  }

  @override
  void dispose() {
    _bgAnimationController.dispose();
    _pulseController.dispose();
    _menuController.dispose();
    super.dispose();
  }
}