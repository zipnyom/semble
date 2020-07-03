import 'package:flutter/material.dart';

class Select with ChangeNotifier {
  int _select;

  int get select => _select;

  set select(int select) {
    _select = select;
    notifyListeners();
  }
}
