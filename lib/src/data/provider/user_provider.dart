import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  FirebaseUser _user;

  FirebaseUser get user => _user;

  set user(FirebaseUser user) {
    _user = user;
    notifyListeners();
  }
}
