import 'package:flutter/material.dart';

class ClassOption with ChangeNotifier {
  DateTime _startDate;

  DateTime get startDate => _startDate;

  set startDate(DateTime startDate) {
    _startDate = startDate;
    notifyListeners();
  }

  DateTime _endDate;

  DateTime get endDate => _endDate;

  set endDate(DateTime endDate) {
    _endDate = endDate;
    notifyListeners();
  }

  List<int> _dayList = List<int>();
  clear() {
    _dayList.clear();
  }

  getDayList() {
    return _dayList;
  }

  containOrder(int order) {
    if (_dayList.contains(order)) return true;
    return false;
  }

  addOrder(int order) {
    _dayList.add(order);
    notifyListeners();
  }

  removeOrder(int order) {
    _dayList.remove(order);
    notifyListeners();
  }
}
