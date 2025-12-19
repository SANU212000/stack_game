import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../../leaderboard/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService;
  final DatabaseService _databaseService;

  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  AuthViewModel({
    required AuthService authService,
    required DatabaseService databaseService,
  }) : _authService = authService,
       _databaseService = databaseService {
    _authService.authStateChanges.listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      final credential = await _authService.signUpWithEmail(email, password);
      if (credential != null && credential.user != null) {
        await _databaseService.saveUserProfile(
          uid: credential.user!.uid,
          email: email,
          username: username,
        );
        _setLoading(false);
        return true;
      }
      _setLoading(false);
      return false;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<bool> signIn({required String email, required String password}) async {
    _setLoading(true);
    _setError(null);
    try {
      await _authService.signInWithEmail(email, password);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }
}
