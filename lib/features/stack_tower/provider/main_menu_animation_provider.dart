import 'package:flutter/material.dart';

/// MainMenuAnimationProvider - Manages UI animations for Main Menu Screen
///
/// Handles all animation controllers and provides them to the UI layer.
/// Created at the view level where TickerProvider is available.
class MainMenuAnimationProvider extends ChangeNotifier {
  late AnimationController _titleController;
  late AnimationController _menuController;
  late Animation<double> _titleAnimation;
  late List<Animation<double>> _menuAnimations;

  // Getters
  Animation<double> get titleAnimation => _titleAnimation;
  List<Animation<double>> get menuAnimations => _menuAnimations;

  MainMenuAnimationProvider(TickerProvider vsync) {
    _initializeAnimations(vsync);
    _startAnimations();
  }

  void _initializeAnimations(TickerProvider vsync) {
    // Title animation
    _titleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: vsync,
    );

    _titleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _titleController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    // Menu items staggered animation
    _menuController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: vsync,
    );

    _menuAnimations = List.generate(4, (index) {
      final startInterval = 0.2 + (index * 0.15);
      final endInterval = (startInterval + 0.3).clamp(0.0, 1.0);
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _menuController,
          curve: Interval(
            startInterval,
            endInterval,
            curve: Curves.easeOutBack,
          ),
        ),
      );
    });
  }

  void _startAnimations() {
    _titleController.forward();
    _menuController.forward();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _menuController.dispose();
    super.dispose();
  }
}