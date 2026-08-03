import 'package:flutter/material.dart';

class AuthUserProvider extends ChangeNotifier {
  String? _userName;
  String? _userEmail;  
  bool _isLoggedIn = false;

  String? get userName => _userName;
  String? get userEmail => _userEmail;
  bool get isLoggedIn => _isLoggedIn;

  void login(String name, String email) {
    _userName = name;
    _userEmail = email;
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _userName = null;
    _userEmail = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}