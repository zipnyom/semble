import 'package:flutter/material.dart';
import 'package:schuul/src/screens/welcome/components/body.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int selectPage = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Body(),);
  }
}
