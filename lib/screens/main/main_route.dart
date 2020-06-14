import 'package:flutter/material.dart';
import 'package:schuul/constants.dart';
import 'package:schuul/presentation/custom_icon_icons.dart';
import 'package:schuul/screens/main/dashboard_page.dart';
import 'package:schuul/screens/main/home/home_page.dart';
import 'package:schuul/screens/main/calendar_page.dart';
import 'package:schuul/screens/main/widgets/spped_dial.dart';
import 'package:schuul/widgets/widget.dart';
import 'account_page.dart';
import 'bottom_nav/fab_bottom_app_bar.dart';

class MainRoute extends StatefulWidget {
  MainRoute({this.email});
  final String email;
  @override
  _MainRouteState createState() => _MainRouteState();
}

class _MainRouteState extends State<MainRoute> {
  static int _selectedIndex = 0;
  void _selectedTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    final List<Widget> _children = [
      HomePage(),
      DashBoardPage(),
      CalendarPage(),
      AccountPage(),
    ];
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar: FABBottomAppBar(
          // centerItemText: 'A',c
          color: Colors.grey,
          selectedColor: kPrimaryColor,
          notchedShape: CircularNotchedRectangle(),
          onTabSelected: _selectedTab,
          items: [
            DateBottomAppBarItem(text: 'Today'),
            FABBottomAppBarItem(iconData: Icons.dashboard, text: '수업관리'),
            FABBottomAppBarItem(iconData: CustomIcon.calendar, text: '캘린더'),
            FABBottomAppBarItem(iconData: CustomIcon.cog, text: '설정'),
          ],
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
        floatingActionButton: MainSpeedDial(),
        body: Padding(
          padding : EdgeInsets.only(top :40)
          ,child : 
          _children[_selectedIndex]));
  }
}
