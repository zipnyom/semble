import 'package:flutter/material.dart';
import 'package:schuul/src/obj/class.dart';

class ClassDateInfo with ChangeNotifier {
  MyClass _myClass;

  MyClass get myClass => _myClass;

  set myClass(MyClass myClass) {
    _myClass = myClass;
    notifyListeners();
  }

  DateTime _startDate;

  DateTime get startDate => _startDate;
  List<DateTime> days = [];
  refreshEvent() {
    if (_startDate != null &&
        _endDate != null &&
        _weekDayList.isEmpty == false) {
      days = List<DateTime>();
      DateTime _tmpDate = _startDate;
      while (_tmpDate != _endDate) {
        if (_weekDayList.contains(_tmpDate.weekday)) {
          days.add(_tmpDate);
        }
        _tmpDate = _tmpDate.add(Duration(days: 1));
      }
      addDaylistToEventmap(days);
    }
  }

  set startDate(DateTime startDate) {
    _startDate = startDate;
    refreshEvent();
    notifyListeners();
  }

  DateTime _endDate;

  DateTime get endDate => _endDate;

  set endDate(DateTime endDate) {
    _endDate = endDate;
    refreshEvent();
    notifyListeners();
  }

  List<int> _weekDayList = List<int>();
  clear() {
    _weekDayList.clear();
  }

  List<int> get weekDays => _weekDayList;

  containWeekDay(int order) {
    if (_weekDayList.contains(order)) return true;
    return false;
  }

  addWeekDay(int order) {
    _weekDayList.add(order);
    refreshEvent();
    notifyListeners();
  }

  removeWeekDay(int order) {
    _weekDayList.remove(order);
    refreshEvent();
    notifyListeners();
  }

  Map<DateTime, List> _events = Map<DateTime, List>();

  Map<DateTime, List> get event => _events;

  contains(DateTime item) {
    if (_events.containsKey(item)) return true;
    return false;
  }

  addDaylistToEventmap(List<DateTime> items) {
    _events.clear();
    items.forEach((element) {
      _events.putIfAbsent(element, () => ["AAA"]);
    });
    notifyListeners();
  }

  removeDaylistfromEventmap(List<DateTime> items) {
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
