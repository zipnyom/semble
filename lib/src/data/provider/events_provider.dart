import 'package:flutter/material.dart';

class Events with ChangeNotifier {
  Map<DateTime, List> _events = Map<DateTime, List>();
  clear() {
    _events.clear();
  }

  Map<DateTime, List> get event => _events;

  contains(DateTime item) {
    if (_events.containsKey(item)) return true;
    return false;
  }

  addList(List<DateTime> items) {
    items.forEach((element) {
      _events.putIfAbsent(element, () => ["AAA"]);
    });
    notifyListeners();
  }

  deleteList(List<DateTime> items) {
    items.forEach((element) {
      _events.remove(element);
    });
    notifyListeners();
  }

  add(DateTime date) {
    _events.putIfAbsent(date, () => ["AAA"]);
    notifyListeners();
  }

  delete(DateTime date) {
    _events.remove(date);
    notifyListeners();
  }
}
