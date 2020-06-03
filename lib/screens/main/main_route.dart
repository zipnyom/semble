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
import 'package:schuul/screens/main/manage_page.dart';
import 'package:schuul/tests/beacon/main_second.dart';
import 'package:schuul/tests/nfc/main_third.dart';
import 'package:schuul/screens/main/calendar.dart';
import 'package:schuul/widgets/widget.dart';

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

    final List<Widget> _children = [MyHomePage(), ManagePage(), DashBoardPage()];
    return Scaffold(
        appBar: appBarMain(context),
        drawer: myDrawer(context),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              title: Text('Business'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              title: Text('School'),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).accentColor,
          onTap: _onBottomItemTapped,
        ),
        body: _children[_selectedIndex]
    );
  }
}
