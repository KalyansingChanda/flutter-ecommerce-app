import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/user_service.dart';

class AuthProvider with ChangeNotifier {
  final UserService _userService = UserService();

  AppUser? _user;
  String? _errorMessage;

  AppUser? get user => _user;
  String? get errorMessage => _errorMessage;

  Future<void> checkAuthState() async {
    // Mock implementation - no persistent auth state
    notifyListeners();
  }

  Future<bool> signInWithEmail(String email, String password) async {
    try {
      _errorMessage = null;
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Mock authentication - accept demo credentials
      if (email == 'demo@example.com' && password == 'password123') {
        _user = AppUser(
          uid: 'demo_user_123',
          name: 'Demo User',
          email: email,
          createdAt: DateTime.now(),
        );
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Invalid email or password';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = _getErrorMessage(e.toString());
      notifyListeners();
    }
    return false;
  }

  Future<bool> signUpWithEmail(String email, String password, String name) async {
    try {
      _errorMessage = null;
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Mock registration - always succeed
      final newUser = AppUser(
        uid: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        email: email,
        createdAt: DateTime.now(),
      );

      await _userService.createUser(newUser);
      _user = newUser;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = _getErrorMessage(e.toString());
      notifyListeners();
    }
    return false;
  }

  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _user = null;
    _errorMessage = null;
    notifyListeners();
  }

  String _getErrorMessage(String error) {
    if (error.contains('user-not-found')) {
      return 'User not found';
    } else if (error.contains('wrong-password')) {
      return 'Wrong password';
    } else if (error.contains('email-already-in-use')) {
      return 'Email already in use';
    } else if (error.contains('weak-password')) {
      return 'Password is too weak';
    } else if (error.contains('invalid-email')) {
      return 'Invalid email';
    }
    return 'Something went wrong';
  }
}