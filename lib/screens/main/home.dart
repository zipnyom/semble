// ignore: must_be_immutable
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:schuul/helper/main_check_image.dart';
import 'package:table_calendar/table_calendar.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  static var isDispose = false;

  //////////////////////////////////////
  //Animated Toast Button for Attendance

  double _dy = 0.0;
  Animation<double> animation;
  AnimationController animationController;

  CalendarController _calendarController;

  void _toastCheckButton() {
    animationController = AnimationController(
        duration: Duration(milliseconds: 1500), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.elasticOut))
      ..addListener(() {
        setState(() {
//          print("value : ${animation.value}");
          _dy = animation.value;
        });
      });
    animationController.forward();
  }

  handleAppLifecycleState() {
    AppLifecycleState _lastLifecyleState;
    // ignore: missing_return
    SystemChannels.lifecycle.setMessageHandler((msg) {
      print('SystemChannels> $msg');
      switch (msg) {
        case "AppLifecycleState.paused":
          _lastLifecyleState = AppLifecycleState.paused;
          break;
        case "AppLifecycleState.inactive":
          _lastLifecyleState = AppLifecycleState.inactive;
          break;
        case "AppLifecycleState.resumed":
          _lastLifecyleState = AppLifecycleState.resumed;
          if (!isDispose) _toastCheckButton();
          break;
        default:
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _calendarController = CalendarController();

    isDispose = false;
    handleAppLifecycleState();
    _toastCheckButton();
  }

  @override
  void dispose() {
    isDispose = true;
    animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
      child: Stack(
        children: <Widget>[
          CustomPaint(size: size, painter: MainCheckButtonPaint(_dy)),
          ListView(
            children: [
              TableCalendar(
                calendarController: _calendarController,
              )
            ],
          )
        ],
      ),
    );
  }
}
