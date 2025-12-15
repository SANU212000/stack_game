import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../model/particle_model.dart';

/// Service for managing visual and haptic effects
/// Handles screen shake, particles, and haptic feedback
class EffectsService extends ChangeNotifier {
  // Screen shake
  double _shakeIntensity = 0;
  double _shakeOffsetX = 0;
  double _shakeOffsetY = 0;
  final Random _random = Random();
  
  // Particles
  final List<ParticleModel> _particles = [];
  
  // Combo effects
  bool _showPerfectText = false;
  int _comboCount = 0;
  double _perfectTextOpacity = 0;
  double _perfectTextScale = 0;
  
  // Getters
  double get shakeOffsetX => _shakeOffsetX;
  double get shakeOffsetY => _shakeOffsetY;
  List<ParticleModel> get particles => List.unmodifiable(_particles);
  bool get showPerfectText => _showPerfectText;
  int get comboCount => _comboCount;
  double get perfectTextOpacity => _perfectTextOpacity;
  double get perfectTextScale => _perfectTextScale;
  
  /// Trigger screen shake effect
  void triggerShake({double intensity = 8.0, int durationMs = 300}) {
    _shakeIntensity = intensity;
    _updateShake();
    
    Future.delayed(Duration(milliseconds: durationMs), () {
      _shakeIntensity = 0;
      _shakeOffsetX = 0;
      _shakeOffsetY = 0;
      notifyListeners();
    });
  }
  
  void _updateShake() {
    if (_shakeIntensity > 0) {
      _shakeOffsetX = (_random.nextDouble() - 0.5) * _shakeIntensity * 2;
      _shakeOffsetY = (_random.nextDouble() - 0.5) * _shakeIntensity * 2;
      _shakeIntensity *= 0.9; // Decay
      notifyListeners();
      
      if (_shakeIntensity > 0.5) {
        Future.delayed(const Duration(milliseconds: 16), _updateShake);
      }
    }
  }
  
  /// Trigger haptic feedback
  void triggerHaptic({HapticType type = HapticType.light}) {
    switch (type) {
      case HapticType.light:
        HapticFeedback.lightImpact();
        break;
      case HapticType.medium:
        HapticFeedback.mediumImpact();
        break;
      case HapticType.heavy:
        HapticFeedback.heavyImpact();
        break;
      case HapticType.selection:
        HapticFeedback.selectionClick();
        break;
    }
  }
  
  /// Spawn confetti particles
  void spawnConfetti(double x, double y, {int count = 20}) {
    for (int i = 0; i < count; i++) {
      _particles.add(ParticleModel.confetti(x: x, y: y, random: _random));
    }
    notifyListeners();
  }
  
  /// Spawn spark particles
  void spawnSparks(double x, double y, {int count = 10, Color? color}) {
    for (int i = 0; i < count; i++) {
      _particles.add(ParticleModel.spark(x: x, y: y, random: _random, baseColor: color));
    }
    notifyListeners();
  }
  
  /// Spawn debris from trimmed block
  void spawnDebris(double x, double y, double width, Color color, {bool goingRight = true}) {
    for (int i = 0; i < 5; i++) {
      _particles.add(ParticleModel.debris(
        x: x,
        y: y,
        width: width / 4,
        color: color,
        random: _random,
        goingRight: goingRight,
      ));
    }
    notifyListeners();
  }
  
  /// Spawn star particles for perfect landing
  void spawnStars(double x, double y, {int count = 15}) {
    for (int i = 0; i < count; i++) {
      _particles.add(ParticleModel.star(x: x, y: y, random: _random));
    }
    notifyListeners();
  }
  
  /// Show "PERFECT!" text animation
  void showPerfect(int combo) {
    _showPerfectText = true;
    _comboCount = combo;
    _perfectTextOpacity = 1;
    _perfectTextScale = 0.5;
    notifyListeners();
    
    _animatePerfectText();
  }
  
  void _animatePerfectText() async {
    // Scale up
    for (int i = 0; i < 10; i++) {
      await Future.delayed(const Duration(milliseconds: 16));
      _perfectTextScale = 0.5 + (i / 10) * 0.7; // Scale from 0.5 to 1.2
      notifyListeners();
    }
    
    // Hold
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Fade out
    for (int i = 10; i >= 0; i--) {
      await Future.delayed(const Duration(milliseconds: 30));
      _perfectTextOpacity = i / 10;
      notifyListeners();
    }
    
    _showPerfectText = false;
    notifyListeners();
  }
  
  /// Update all particles (call every frame)
  void updateParticles(double deltaTime) {
    // Update existing particles
    for (int i = _particles.length - 1; i >= 0; i--) {
      _particles[i] = _particles[i].update(deltaTime);
      
      // Remove dead particles
      if (!_particles[i].isAlive) {
        _particles.removeAt(i);
      }
    }
    
    if (_particles.isNotEmpty) {
      notifyListeners();
    }
  }
  
  /// Clear all particles
  void clearParticles() {
    _particles.clear();
    notifyListeners();
  }
  
  /// Block landing effect (combines multiple effects)
  void onBlockLanded({
    required double x,
    required double y,
    required bool isPerfect,
    required int combo,
    Color? blockColor,
  }) {
    if (isPerfect) {
      // Perfect landing effects
      spawnStars(x, y, count: 12);
      spawnConfetti(x, y - 20, count: 25);
      showPerfect(combo);
      triggerShake(intensity: 4.0, durationMs: 150);
      triggerHaptic(type: HapticType.medium);
    } else {
      // Normal landing effects
      spawnSparks(x, y, count: 8, color: blockColor);
      triggerShake(intensity: 2.0, durationMs: 100);
      triggerHaptic(type: HapticType.light);
    }
  }
  
  /// Block trimmed effect
  void onBlockTrimmed({
    required double x,
    required double y,
    required double trimmedWidth,
    required Color color,
    required bool trimmedFromRight,
  }) {
    spawnDebris(x, y, trimmedWidth, color, goingRight: trimmedFromRight);
  }
  
  /// Game over effect
  void onGameOver(double x, double y) {
    triggerShake(intensity: 15.0, durationMs: 500);
    triggerHaptic(type: HapticType.heavy);
    spawnConfetti(x, y, count: 30);
  }
}

/// Types of haptic feedback
enum HapticType {
  light,
  medium,
  heavy,
  selection,
}
