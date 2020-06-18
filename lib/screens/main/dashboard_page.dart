import 'package:flutter/material.dart';
import 'package:schuul/presentation/custom_icon_icons.dart';
import 'package:schuul/screens/main/widgets/sub_title.dart';
import 'package:schuul/widgets/widget.dart';

class DashBoardPage extends StatefulWidget {
  @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar("수업관리", false, []),
        body: Container(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SubTitle(
                title: "수업 리스트",
                icon: CustomIcon.graduation_cap,
                actions: [],
              ),
              SizedBox(
                height: 20,
              ),
              SubTitle(
                title: "수업 히스토리",
                icon: CustomIcon.graduation_cap,
                actions: [],
              ),
            ],
          ),
        )));
  }
}
