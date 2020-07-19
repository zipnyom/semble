import 'package:flutter/material.dart';
import 'package:schuul/src/constants.dart';

class AttendScreen extends StatefulWidget {
  @override
  _AttendScreenState createState() => _AttendScreenState();
}

class _AttendScreenState extends State<AttendScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            "출결 관리",
            style: TextStyle(color: kTextColor),
          ),
          iconTheme: IconThemeData(
            color: kTextColor, //change your color here
          ),
          brightness: Brightness.light,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Color(0xFFb5bfd0),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0.0,
          actions: [],
          bottom: TabBar(
            tabs: [
              Tab(
                child: Container(
                    child: Text("전체",
                        style: TextStyle(fontSize: 18, color: kTextColor))),
              ),
              Tab(
                child: Text("일별",
                    style: TextStyle(fontSize: 18, color: kTextColor)),
              ),
            ],
          ),
//    centerTitle: false,
        ),
        body: TabBarView(
          children: [
            Container(child: Text("전체")),
            Icon(Icons.directions_transit),
          ],
        ),
      ),
    );
  }
}
