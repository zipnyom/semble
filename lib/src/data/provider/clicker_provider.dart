import 'package:flutter/material.dart';
import 'package:schuul/src/obj/vote.dart';

class MyClicker with ChangeNotifier {
  List<Vote> _clickerList = [];

  List<Vote> get clickerList => _clickerList;

  set clickerList(List<Vote> clickerList) {
    _clickerList = clickerList;
    notifyListeners();
  }
}
