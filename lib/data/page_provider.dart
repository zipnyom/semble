import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:schuul/screens/main/account_page.dart';
import 'package:schuul/screens/main/calendar_page.dart';
import 'package:schuul/screens/main/dashboard_page.dart';
import 'package:schuul/screens/main/home/home_page.dart';

class PageProvider extends ChangeNotifier {
  // bool _isJoin = false;

  // bool get isJoin => _isJoin;

  // void toggle() {
  //   _isJoin = !_isJoin;
  //   notifyListeners();
  // }

  static List<List<Widget>> _pages = [
    [HomePage()],
    [DashBoardPage()],
    [CalendarPage()],
    [AccountPage()],
  ];
  List<List<Widget>> get pages => _pages;

  Widget _currentBody = _pages[0][0];
  Widget get currentBody => _currentBody;
  set currentBody(Widget currentBody) {
    _currentBody = currentBody;
    notifyListeners();
  }

  Widget _currentAppBar = _pages[0][0];
  Widget get currentAppBar => _currentAppBar;
  set currentAppBar(Widget currentAppBar) {
    _currentAppBar = currentAppBar;
    notifyListeners();
  }
}
