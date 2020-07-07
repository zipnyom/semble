import 'package:flutter/material.dart';
import 'package:schuul/src/obj/vote_item.dart';

class Select with ChangeNotifier {
  List<int> _orderList = List<int>();
  List<VoteItem> _itemList = List<VoteItem>();
  bool _already = false;

  clear() {
    _orderList.clear();
    _itemList.clear();
  }

  getItemList() {
    return _itemList;
  }

  containOrder(int order) {
    if (_orderList.contains(order)) return true;
    return false;
  }

  addOrder(int order) {
    _orderList.add(order);
    notifyListeners();
  }

  removeOrder(int order) {
    _orderList.remove(order);
    notifyListeners();
  }

  addItem(VoteItem item) {
    _itemList.add(item);
    notifyListeners();
  }

  removeItem(VoteItem item) {
    _itemList.remove(item);
    notifyListeners();
  }

  bool get already => _already;

  set already(bool already) {
    _already = already;
    notifyListeners();
  }
}
