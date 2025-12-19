import 'dart:async';
import 'package:flutter/material.dart';
import '../repositories/leaderboard_repository.dart';
import '../models/leaderboard_entry.dart';

class LeaderboardViewModel extends ChangeNotifier {
  final ILeaderboardRepository _leaderboardRepository;
  StreamSubscription? _subscription;

  List<LeaderboardEntry> _entries = [];
  bool _isLoading = true;
  String _selectedMonth = 'Monthly';

  final List<String> _months = ['Monthly', 'Weekly', 'All Time'];

  LeaderboardViewModel({required ILeaderboardRepository leaderboardRepository})
    : _leaderboardRepository = leaderboardRepository {
    _initLeaderboard();
  }

  List<LeaderboardEntry> get entries => _entries;
  bool get isLoading => _isLoading;
  String get selectedMonth => _selectedMonth;
  List<String> get months => _months;

  List<LeaderboardEntry> get topThree {
    if (_entries.isEmpty) return [];
    if (_entries.length < 3) return List<LeaderboardEntry>.from(_entries);

    // We want Rank 2, Rank 1, Rank 3 in the UI Row
    final top = _entries.take(3).toList();
    if (top.length >= 3) {
      return [top[1], top[0], top[2]];
    }
    return top;
  }

  List<LeaderboardEntry> get remainingEntries {
    if (_entries.length <= 3) return [];
    return _entries.sublist(3);
  }

  void _initLeaderboard() {
    _subscription = _leaderboardRepository.getLeaderboardStream().listen(
      (entries) {
        _entries = entries;
        _isLoading = false;
        notifyListeners();
      },
      onError: (error) {
        debugPrint('Error fetching leaderboard: $error');
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  void setMonth(String month) {
    if (_selectedMonth == month) return;
    _selectedMonth = month;
    _isLoading = true;
    notifyListeners();

    // Simulate filter delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _isLoading = false;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
