import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schuul/data/page_provider.dart';
import 'package:schuul/screens/main/main_route.dart';
import 'package:schuul/screens/welcome/components/body.dart';

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
