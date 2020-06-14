
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schuul/constants.dart';
import 'package:schuul/data/page_provider.dart';
import 'package:schuul/presentation/custom_icon_icons.dart';
import 'package:schuul/screens/main/bottom_nav/fab_bottom_app_bar.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pages = Provider.of<PageProvider>(context);
    void _selectedTab(int index) {
      pages.currentBody = pages.pages[index][0];
    }

    return FABBottomAppBar(
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
    );
  }
}
CustomBottomNavBar customBottomNavBar = CustomBottomNavBar();
