import 'package:flutter/material.dart';
import 'package:schuul/widgets/widget.dart';

class DashBoardPage extends StatefulWidget {
  @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar("수업관리", false, []), body: Container());
  }
}
