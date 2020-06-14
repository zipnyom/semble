import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schuul/data/page_provider.dart';
import 'package:schuul/screens/main/widgets/custom_nav_bar.dart';
import 'package:schuul/screens/main/widgets/spped_dial.dart';

class MainRoute extends StatefulWidget {
  MainRoute({this.email});
  final String email;
  @override
  _MainRouteState createState() => _MainRouteState();
}

class _MainRouteState extends State<MainRoute> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageProvider>(
      builder: (_, pages, child) => Scaffold(
          bottomNavigationBar: customBottomNavBar,
          // floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
          floatingActionButton: MainSpeedDial(),
          body: Padding(
              padding: EdgeInsets.only(top: 40), child: pages.currentBody)),
    );
  }
}

