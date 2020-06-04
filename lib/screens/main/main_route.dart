import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:schuul/data/join_or_login.dart';
import 'package:schuul/helper/main_check_image.dart';
import 'package:schuul/screens/main/dashboard_page.dart';
import 'package:schuul/screens/main/home/home_page.dart';
import 'package:schuul/tests/beacon/main_second.dart';
import 'package:schuul/tests/nfc/main_third.dart';
import 'package:schuul/screens/main/calendar_page.dart';
import 'package:schuul/widgets/widget.dart';

import 'account_page.dart';

class MainPageBottomCircle extends StatefulWidget {
  MainPageBottomCircle({this.email});

  final String email;

  @override
  _MainPageBottomCircleState createState() => _MainPageBottomCircleState();
}

class _MainPageBottomCircleState extends State<MainPageBottomCircle> {
  static int _selectedIndex = 0;

  void _onBottomItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _children = [
      HomePage(),
      CalendarPage(),
      DashBoardPage(),
      AccountPage()
    ];
    final String dummyTitle = '______';

    return Scaffold(
        appBar: appBarMain(context),
//        drawer: myDrawer(context),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text(dummyTitle),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.today),
              title: Text(dummyTitle),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.insert_chart),
              title: Text(dummyTitle),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              title: Text(dummyTitle),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).accentColor,
          onTap: _onBottomItemTapped,
        ),
        body: _children[_selectedIndex]);
  }
}
