import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';
import '../services/user_service.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService _userService = UserService();

  AppUser? _user;
  String? _errorMessage;

  AppUser? get user => _user;
  String? get errorMessage => _errorMessage;

  Future<void> checkAuthState() async {
    final User? firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      _user = await _userService.getUser(firebaseUser.uid);
    }
    notifyListeners();
  }

  Future<bool> signInWithEmail(String email, String password) async {
    try {
      _errorMessage = null;
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        _user = await _userService.getUser(result.user!.uid);
        notifyListeners();
        return true;
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
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        final newUser = AppUser(
          uid: result.user!.uid,
          name: name,
          email: email,
          createdAt: DateTime.now(),
        );

        await _userService.createUser(newUser);
        _user = newUser;
        notifyListeners();
        return true;
      }
    } catch (e) {
      _errorMessage = _getErrorMessage(e.toString());
      notifyListeners();
    }
    return false;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    _errorMessage = null;
    notifyListeners();
  }

  String _getErrorMessage(String error) {
    if (error.contains('user-not-found')) {
      return 'वापरकर्ता सापडला नाही';
    } else if (error.contains('wrong-password')) {
      return 'चुकीचा पासवर्ड';
    } else if (error.contains('email-already-in-use')) {
      return 'हा ईमेल आधीच वापरला आहे';
    } else if (error.contains('weak-password')) {
      return 'पासवर्ड कमकुवत आहे';
    } else if (error.contains('invalid-email')) {
      return 'चुकीचा ईमेल';
    }
    return 'काहीतरी चूक झाली';
  }
}