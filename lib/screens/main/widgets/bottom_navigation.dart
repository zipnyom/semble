import 'package:flutter/material.dart';
import 'package:schuul/constants.dart';
import 'package:schuul/presentation/custom_icon_icons.dart';
import 'package:schuul/screens/main/account_page.dart';
import 'package:schuul/screens/main/calendar_page.dart';
import 'package:schuul/screens/main/dashboard_page.dart';
import 'package:schuul/screens/main/home/home_page.dart';

enum TabItem { home, dashboard, calendar, setting }

Map<TabItem, String> tabName = {
  TabItem.home: 'Today',
  TabItem.dashboard: '수업관리',
  TabItem.calendar: '캘린더',
  TabItem.setting: '설정',
};
Map<TabItem, Widget> activeTab = {
  TabItem.home: HomePage(),
  TabItem.dashboard: DashBoardPage(),
  TabItem.calendar: CalendarPage(),
  TabItem.setting: AccountPage()
};

Map<TabItem, IconData> tabIcon = {
  TabItem.home: CustomIcon.heart,
  TabItem.dashboard: CustomIcon.params,
  TabItem.calendar: CustomIcon.calendar,
  TabItem.setting: CustomIcon.cog
};

class BottomNavigation extends StatelessWidget {
  BottomNavigation({this.currentTab, this.onSelectTab});
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        _buildItem(tabItem: TabItem.home),
        _buildItem(tabItem: TabItem.dashboard),
        _buildItem(tabItem: TabItem.calendar),
        _buildItem(tabItem: TabItem.setting),
      ],
      onTap: (index) => onSelectTab(
        TabItem.values[index],
      ),
    );
  }

  BottomNavigationBarItem _buildItem({TabItem tabItem}) {
    String text = tabName[tabItem];
    return BottomNavigationBarItem(
      icon: Icon(
        tabIcon[tabItem],
        color: _colorTabMatching(item: tabItem),
      ),
      title: Text(
        text,
        style: TextStyle(color: _colorTabMatching(item: tabItem),),
      ),
    );
  }

  Color _colorTabMatching({TabItem item}) {
    return currentTab == item ? kPrimaryColor : Colors.grey;
  }
}
