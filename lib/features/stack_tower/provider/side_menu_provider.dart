import 'package:flutter/material.dart';
import 'package:slack_game/features/stack_tower/provider/stack_tower_provider.dart';

class SideMenuProvider extends ChangeNotifier {
  bool _isMenuOpen = false;
  bool get isMenuOpen => _isMenuOpen;
  AnimationController? _menuController;

  void init(AnimationController controller) {
    _menuController = controller;
    _isMenuOpen = false;
    // Don't notify here to avoid build errors during initState
  }

  void toggleMenu(StackTowerProvider viewModel) {
    if (_menuController == null) return;

    _isMenuOpen = !_isMenuOpen;
    notifyListeners();

    if (_isMenuOpen) {
      _menuController!.forward();
      viewModel.pauseGame();
    } else {
      _menuController!.reverse();
      viewModel.resumeGame();
    }
  }

  void closeMenu(StackTowerProvider viewModel) {
    if (!_isMenuOpen || _menuController == null) return;

    _isMenuOpen = false;
    notifyListeners();

    _menuController!.reverse();
    viewModel.resumeGame();
  }
}
