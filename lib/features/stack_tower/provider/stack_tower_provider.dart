import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../model/block_model.dart';
import '../model/game_state_model.dart';
import '../model/animation_model.dart';
import '../services/storage_service.dart';
import '../services/effects_service.dart';
import '../services/settings_service.dart';
import '../../../core/constants/app_colors.dart';
import 'animation_provider.dart';

/// StackTowerProvider - Main ViewModel for Stack Tower Game
///
/// Responsibilities:
/// - Manages complete game state and logic
/// - Handles block movement and positioning
/// - Calculates alignment and trimming
/// - Updates score and high score
/// - Tracks combos and perfect landings
/// - NO UI code - pure business logic and state management
///
/// Architecture: Uses ChangeNotifier for state management
class StackTowerProvider extends ChangeNotifier {
  final StorageService _storageService;
  final EffectsService _effectsService;
  final SettingsService _settingsService;
  final AppColorProvider _appColorProvider;
  final AnimationProvider _animationProvider;

  // Game State
  GameStateModel _gameState = const GameStateModel();
  final List<BlockModel> _placedBlocks = [];
  BlockModel? _currentBlock;
  AnimationModel _animationModel = const AnimationModel();

  // Movement tracking
  bool _movingRight = true;
  Timer? _movementTimer;
  Timer? _particleTimer;

  // Getters
  GameStateModel get gameState => _gameState;
  List<BlockModel> get placedBlocks => List.unmodifiable(_placedBlocks);
  BlockModel? get currentBlock => _currentBlock;
  AnimationModel get animationModel => _animationModel;
  bool get isMovingRight => _movingRight;
  EffectsService get effectsService => _effectsService;

  // Animation Getters (delegate to animation provider)
  Animation<double> get bgAnimation => _animationProvider.bgAnimation;
  Animation<double> get pulseAnimation => _animationProvider.pulseAnimation;
  Animation<double> get menuAnimation => _animationProvider.menuAnimation;
  AnimationController get menuController => _animationProvider.menuController;

  StackTowerProvider({
    required StorageService storageService,
    required EffectsService effectsService,
    required SettingsService settingsService,
    required AppColorProvider appColorProvider,
    required AnimationProvider animationProvider,
  }) : _storageService = storageService,
       _effectsService = effectsService,
       _settingsService = settingsService,
       _appColorProvider = appColorProvider,
       _animationProvider = animationProvider {
    initializeGame();
    _startParticleUpdater();
  }

  /// Start particle update loop
  void _startParticleUpdater() {
    _particleTimer?.cancel();
    _particleTimer = Timer.periodic(
      const Duration(milliseconds: 16), // ~60fps
      (timer) {
        _effectsService.updateParticles(0.016);
        // Notify listeners for particle updates
        notifyListeners();
      },
    );
  }

  /// Initialize the game
  Future<void> initializeGame() async {
    final bestScore = await _storageService.getHighScore();
    _gameState = _gameState.copyWith(
      bestScore: bestScore,
      status: AppConstants.gameStateInitial,
    );
    notifyListeners();
  }

  /// Start a new game
  Future<void> startGame() async {
    _placedBlocks.clear();
    _currentBlock = null;
    _effectsService.clearParticles();

    _gameState = GameStateModel(
      score: 0,
      bestScore: _gameState.bestScore,
      status: AppConstants.gameStatePlaying,
      isMoving: true,
      combo: 0,
      maxCombo: 0,
      perfectLandings: 0,
      level: 1,
      speedMultiplier: 1.0,
    );
    _animationModel = const AnimationModel();

    // Load best score
    final bestScore = await _storageService.getHighScore();
    _gameState = _gameState.copyWith(bestScore: bestScore);

    // Place first block fixed at bottom center (not moving)
    final firstBlock = BlockModel.initial();
    _placedBlocks.add(firstBlock);
    _gameState = _gameState.copyWith(score: 1);

    // Create first moving block at the top
    _createNewBlock();
    _startMovement();
    notifyListeners();
  }

  /// Create a new block at the top (will drop down)
  void _createNewBlock() {
    final lastBlock = _placedBlocks.last;
    _currentBlock = BlockModel.moving(
      width: lastBlock.width,
      index: _placedBlocks.length,
    );
  }

  /// Get current block speed with difficulty and level multipliers
  double get _currentSpeed {
    // Base speed * difficulty multiplier * level progression multiplier
    return AppConstants.blockSpeed *
        _settingsService.speedMultiplier *
        _gameState.speedMultiplier;
  }

  /// Start horizontal movement animation
  void _startMovement() {
    _movementTimer?.cancel();
    _movementTimer = Timer.periodic(
      const Duration(milliseconds: 16), // ~60fps
      (timer) {
        if (_currentBlock == null || !_gameState.isPlaying) {
          timer.cancel();
          return;
        }

        _updateBlockPosition();
        notifyListeners();
      },
    );
  }

  /// Update block position based on movement direction
  void _updateBlockPosition() {
    if (_currentBlock == null) return;

    final block = _currentBlock!;
    double newX = block.x;

    if (_movingRight) {
      newX += _currentSpeed;
      if (block.right >= AppConstants.towerAreaWidth) {
        _movingRight = false;
        newX = AppConstants.towerAreaWidth - block.width / 2;
      }
    } else {
      newX -= _currentSpeed;
      if (block.left <= 0) {
        _movingRight = true;
        newX = block.width / 2;
      }
    }

    _currentBlock = block.copyWith(x: newX);
  }

  /// Handle tap - drop the current block
  void onTap() {
    if (!_gameState.isPlaying || _currentBlock == null) return;

    _movementTimer?.cancel();
    _dropBlock();
  }

  /// Check if landing is perfect (within tolerance)
  bool _isPerfectLanding(BlockModel dropped, BlockModel last) {
    final offset = (dropped.x - last.x).abs();
    return offset <= AppConstants.perfectLandingTolerance;
  }

  /// Drop the block and process alignment/trimming
  Future<void> _dropBlock() async {
    if (_currentBlock == null) return;

    _gameState = _gameState.copyWith(isMoving: false);
    _animationModel = _animationModel.copyWith(isAnimating: true);
    notifyListeners();

    final lastBlock = _placedBlocks.last;
    final targetY = lastBlock.y - AppConstants.initialBlockHeight;

    // Animate drop by moving Y position
    final droppedBlock = _currentBlock!;
    final startY = droppedBlock.y;
    final steps = 30;
    final stepDuration = _animationModel.dropDuration / steps;
    final yStep = (targetY - startY) / steps;

    for (int i = 0; i <= steps; i++) {
      final currentY = startY + (yStep * i);
      _currentBlock = droppedBlock.copyWith(y: currentY);
      notifyListeners();
      await Future.delayed(Duration(milliseconds: stepDuration.round()));
    }

    // Now process alignment and trimming
    final finalBlock = _currentBlock!;
    final isPerfect = _isPerfectLanding(finalBlock, lastBlock);

    // Calculate alignment and trim
    final trimmedBlock = _calculateAlignmentAndTrim(finalBlock, isPerfect);
    final positionedBlock = trimmedBlock.copyWith(
      y: lastBlock.y - trimmedBlock.height,
    );

    // Check if block is too small BEFORE adding to placed blocks
    if (positionedBlock.width < AppConstants.minBlockWidth) {
      await _endGame();
      return;
    }

    // Trigger visual effects
    final blockCenterX = positionedBlock.x;
    final blockTopY = positionedBlock.y;

    if (isPerfect) {
      // Perfect landing!
      final newCombo = _gameState.combo + 1;
      final newMaxCombo = newCombo > _gameState.maxCombo
          ? newCombo
          : _gameState.maxCombo;

      _gameState = _gameState.copyWith(
        combo: newCombo,
        maxCombo: newMaxCombo,
        perfectLandings: _gameState.perfectLandings + 1,
      );

      final colorList = _appColorProvider.blockColors;
      final blockColor =
          colorList[positionedBlock.colorIndex % colorList.length];

      _effectsService.onBlockLanded(
        x: blockCenterX,
        y: blockTopY,
        isPerfect: true,
        combo: newCombo,
        blockColor: blockColor,
      );
    } else {
      // Normal landing - reset combo
      // Spawn debris for trimmed part
      final originalWidth = finalBlock.width;
      final trimmedWidth = originalWidth - positionedBlock.width;
      final colorList = _appColorProvider.blockColors;
      final blockColor =
          colorList[positionedBlock.colorIndex % colorList.length];

      if (trimmedWidth > 5) {
        final trimmedFromRight = finalBlock.x > lastBlock.x;
        _effectsService.onBlockTrimmed(
          x: trimmedFromRight ? positionedBlock.right : positionedBlock.left,
          y: blockTopY,
          trimmedWidth: trimmedWidth,
          color: blockColor,
          trimmedFromRight: trimmedFromRight,
        );
      }

      _gameState = _gameState.copyWith(combo: 0);

      _effectsService.onBlockLanded(
        x: blockCenterX,
        y: blockTopY,
        isPerfect: false,
        combo: 0,
        blockColor: blockColor,
      );
    }

    // Add to placed blocks
    _placedBlocks.add(positionedBlock);
    _currentBlock = null;

    // Update score - increment by 1 (don't use _placedBlocks.length as scrolling removes blocks)
    final newScore = _gameState.score + 1;

    // Calculate new level and speed
    final newLevel = (newScore / AppConstants.blocksPerLevel).floor() + 1;
    final newSpeedMultiplier =
        (1.0 + (newLevel - 1) * AppConstants.speedIncreasePerLevel).clamp(
          1.0,
          AppConstants.maxSpeedMultiplier,
        );

    _gameState = _gameState.copyWith(
      score: newScore,
      level: newLevel,
      speedMultiplier: newSpeedMultiplier,
    );

    // Update high score if needed
    if (_gameState.score > _gameState.bestScore) {
      await _storageService.saveHighScore(_gameState.score);
      _gameState = _gameState.copyWith(bestScore: _gameState.score);
    }

    // Scroll mechanism
    if (_gameState.score > AppConstants.scrollThreshold) {
      _scrollTowerIfNeeded();
    }

    // Create next block at the top
    _createNewBlock();
    _gameState = _gameState.copyWith(isMoving: true);
    _animationModel = _animationModel.copyWith(isAnimating: false);
    _startMovement();
    notifyListeners();
  }

  /// Scroll the tower down when blocks get too high
  void _scrollTowerIfNeeded() {
    if (_placedBlocks.length < 2) return;

    final topBlock = _placedBlocks.last;

    // Check if the tower has grown too tall (top block is above middle line)
    if (topBlock.y <= AppConstants.towerMiddleLine) {
      final shiftDown = AppConstants.initialBlockHeight;

      // Shift all blocks down
      final newPlacedBlocks = <BlockModel>[];

      for (int i = 0; i < _placedBlocks.length; i++) {
        final block = _placedBlocks[i];
        final newY = block.y + shiftDown;

        // Only keep blocks that are still visible in the tower area
        if (newY < AppConstants.towerAreaHeight) {
          newPlacedBlocks.add(block.copyWith(y: newY));
        }
      }

      _placedBlocks.clear();
      _placedBlocks.addAll(newPlacedBlocks);
    }
  }

  /// Calculate alignment and trim the block if misaligned
  /// If perfect landing, keep full width
  BlockModel _calculateAlignmentAndTrim(
    BlockModel droppedBlock,
    bool isPerfect,
  ) {
    final lastBlock = _placedBlocks.last;

    // Perfect landing - keep full width and center on last block
    if (isPerfect) {
      return droppedBlock.copyWith(x: lastBlock.x, width: lastBlock.width);
    }

    // Calculate overlap region
    final overlapLeft = droppedBlock.left > lastBlock.left
        ? droppedBlock.left
        : lastBlock.left;
    final overlapRight = droppedBlock.right < lastBlock.right
        ? droppedBlock.right
        : lastBlock.right;

    final newWidth = (overlapRight - overlapLeft).clamp(0.0, double.infinity);

    if (newWidth <= 0 || newWidth < AppConstants.minBlockWidth) {
      return droppedBlock.copyWith(
        width: 0,
        x: (overlapLeft + overlapRight) / 2,
      );
    }

    final overlapCenterX = (overlapLeft + overlapRight) / 2;

    return droppedBlock.copyWith(width: newWidth, x: overlapCenterX);
  }

  /// End the game
  Future<void> _endGame() async {
    _movementTimer?.cancel();

    // Trigger game over effects
    if (_placedBlocks.isNotEmpty) {
      final lastBlock = _placedBlocks.last;
      _effectsService.onGameOver(lastBlock.x, lastBlock.y);
    }

    _currentBlock = null;
    _gameState = _gameState.copyWith(
      status: AppConstants.gameStateGameOver,
      isMoving: false,
    );
    _animationModel = _animationModel.copyWith(isAnimating: false);
    notifyListeners();
  }

  /// Pause the game
  void pauseGame() {
    if (!_gameState.isPlaying) return;

    _movementTimer?.cancel();
    _particleTimer?.cancel();

    _gameState = _gameState.copyWith(status: AppConstants.gameStatePaused);
    _animationModel = _animationModel.copyWith(isAnimating: false);
    notifyListeners();
  }

  /// Resume the game
  void resumeGame() {
    if (_gameState.status != AppConstants.gameStatePaused) return;

    _gameState = _gameState.copyWith(status: AppConstants.gameStatePlaying);

    // Resume timers
    _startParticleUpdater();

    if (_currentBlock != null) {
      _gameState = _gameState.copyWith(isMoving: true);
      _startMovement();
    }

    notifyListeners();
  }

  /// Restart the game
  Future<void> restartGame() async {
    await startGame();
  }

  @override
  void dispose() {
    _movementTimer?.cancel();
    _particleTimer?.cancel();
    // Animation controllers are disposed by AnimationProvider
    super.dispose();
  }
}