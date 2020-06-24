import 'package:flutter/material.dart';
import 'package:schuul/src/obj/clicker.dart';

class MyClicker with ChangeNotifier {
  List<Clicker> _clickerList = [];

  List<Clicker> get clickerList => _clickerList;

  set clickerList(List<Clicker> clickerList) {
    _clickerList = clickerList;
    notifyListeners();
  }
}
