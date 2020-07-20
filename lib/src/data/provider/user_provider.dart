import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:schuul/src/obj/user_detail.dart';

class UserProvider with ChangeNotifier {
  UserDetail _userDetail;

  UserDetail get userDetail => _userDetail;

  set userDetail(UserDetail userExtra) {
    _userDetail = userExtra;
    notifyListeners();
  }

  FirebaseUser _user;

  FirebaseUser get user => _user;

  set user(FirebaseUser user) {
    _user = user;
    notifyListeners();
  }
}
