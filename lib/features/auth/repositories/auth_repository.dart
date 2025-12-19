import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

abstract class IAuthRepository {
  Stream<User?> get authStateChanges;
  Future<UserCredential?> signInWithEmail(String email, String password);
  Future<UserCredential?> signUpWithEmail(String email, String password);
  Future<void> signOut();
  User? get currentUser;
}

class AuthRepository implements IAuthRepository {
  final AuthService _authService;

  AuthRepository({required AuthService authService})
    : _authService = authService;

  @override
  Stream<User?> get authStateChanges => _authService.authStateChanges;

  @override
  Future<UserCredential?> signInWithEmail(String email, String password) {
    return _authService.signInWithEmail(email, password);
  }

  @override
  Future<UserCredential?> signUpWithEmail(String email, String password) {
    return _authService.signUpWithEmail(email, password);
  }

  @override
  Future<void> signOut() => _authService.signOut();

  @override
  User? get currentUser => _authService.currentUser;
}
