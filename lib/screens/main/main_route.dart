import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:schuul/constants.dart';
import 'package:schuul/presentation/custom_icon_icons.dart';
import 'package:schuul/screens/main/dashboard_page.dart';
import 'package:schuul/screens/main/home/home_page.dart';
import 'package:schuul/screens/main/calendar_page.dart';
import 'package:schuul/widgets/widget.dart';

import 'account_page.dart';
import 'bottom_nav/fab_bottom_app_bar.dart';
import 'bottom_nav/fab_with_icons.dart';
import 'bottom_nav/layout.dart';
import 'bottom_nav_bar.dart';

class MainRoute extends StatefulWidget {
  MainRoute({this.email});
  final String email;
  @override
  _MainRouteState createState() => _MainRouteState();
}

class _MainRouteState extends State<MainRoute> {
  static int _selectedIndex = 0;
  String _lastSelected = 'TAB: 0';

  void _selectedTab(int index) {
    setState(() {
      _lastSelected = 'TAB: $index';
    });
  }

  void _selectedFab(int index) {
    setState(() {
      _lastSelected = 'FAB: $index';
    });
  }

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

    var bottomNavigationBar2 = BottomNavigationBar(
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
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Theme.of(context).accentColor,
      onTap: _onBottomItemTapped,
    );

    return Scaffold(
        appBar: appBarMain(context),
        //        drawer: myDrawer(context),
        // bottomNavigationBar: BottomNavBar(selectedIndex: _selectedIndex),
        // bottomNavigationBar: bottomNavigationBar2,
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
        floatingActionButton: SpeedDial(
          backgroundColor: kPrimaryColor,
          animatedIcon: AnimatedIcons.menu_close,
          onOpen: () {},
          onClose: () {},
          curve: Curves.elasticIn,
          children: [
            SpeedDialChild(
              child: Icon(Icons.accessibility, color: Colors.white),
              backgroundColor: Colors.deepOrange,
              onTap: () => print('FIRST CHILD'),
              label: 'First Child',
              labelStyle: TextStyle(fontWeight: FontWeight.w500),
              labelBackgroundColor: Colors.deepOrangeAccent,
            ),
            SpeedDialChild(
              child: Icon(Icons.brush, color: Colors.white),
              backgroundColor: Colors.green,
              onTap: () => print('SECOND CHILD'),
              label: 'Second Child',
              labelStyle: TextStyle(fontWeight: FontWeight.w500),
              labelBackgroundColor: Colors.green,
            ),
            SpeedDialChild(
              child: Icon(Icons.keyboard_voice, color: Colors.white),
              backgroundColor: Colors.blue,
              onTap: () => print('THIRD CHILD'),
              labelWidget: Container(
                color: Colors.blue,
                margin: EdgeInsets.only(right: 10),
                padding: EdgeInsets.all(6),
                child: Text('Custom Label Widget'),
              ),
            ),
          ],
        ),
        // floatingActionButton: _buildFab(context),
        body: _children[_selectedIndex]);
  }

  Widget _buildFab(BuildContext context) {
    final icons = [Icons.sms, Icons.mail, Icons.phone];
    return AnchoredOverlay(
      showOverlay: true,
      overlayBuilder: (context, offset) {
        return CenterAbout(
          position: Offset(offset.dx, offset.dy - icons.length * 35.0),
          child: FabWithIcons(
            icons: icons,
            onIconTapped: _selectedFab,
          ),
        );
      },
      child: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: Icon(Icons.check),
        elevation: 2.0,
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            offset: Offset(0, -7), blurRadius: 33, color: Color(0xFF6DAED9))
      ]),
      child: Row(),
    );
  }
}
