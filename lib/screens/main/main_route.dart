import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schuul/constants.dart';
import 'package:schuul/data/page_provider.dart';
import 'package:schuul/presentation/custom_icon_icons.dart';
import 'package:schuul/screens/main/widgets/spped_dial.dart';
import 'bottom_nav/fab_bottom_app_bar.dart';

class MainRoute extends StatefulWidget {
  MainRoute({this.email});
  final String email;
  @override
  _MainRouteState createState() => _MainRouteState();
}

class _MainRouteState extends State<MainRoute> {
  @override
  Widget build(BuildContext context) {
    final pages = Provider.of<PageProvider>(context);

    void _selectedTab(int index) {
      setState(() {
        pages.currentBody = pages.pages[index][0];
      });
    }

    return Consumer<PageProvider>(
      builder: (_, pages, child) => Scaffold(
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
              padding: EdgeInsets.only(top: 40), child: pages.currentBody)),
    );
  }
}
