import 'package:flutter/material.dart';
import 'package:schuul/src/obj/vote_item.dart';

class Select with ChangeNotifier {
  int _order;
  VoteItem _item;
  bool _already = false;

  bool get already => _already;

  set already(bool already) {
    _already = already;
    notifyListeners();
  }

  VoteItem get item => _item;

  set item(VoteItem item) {
    _item = item;
    notifyListeners();
  }

  int get order => _order;

  set order(int select) {
    _order = select;
    notifyListeners();
  }
}
