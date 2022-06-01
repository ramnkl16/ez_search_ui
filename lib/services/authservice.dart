import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  bool _authenticated = false;
  AuthService() {
    print("AuthService|constructor $_authenticated");
  }

  bool get authenticated {
    print("AuthService|getter $_authenticated");
    return _authenticated;
  }

  set authenticated(bool value) {
    print("authenticated|setter|$value");
    _authenticated = value;
    notifyListeners();
  }
}
