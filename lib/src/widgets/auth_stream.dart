import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:schuul/src/screens/main/main_route.dart';
import 'package:schuul/src/screens/welcome/welcome_screen.dart';
import 'package:showcaseview/showcaseview.dart';

class AuthStream extends StatefulWidget {
  const AuthStream({
    Key key,
  }) : super(key: key);

  @override
  _AuthStreamState createState() => _AuthStreamState();
}

class _AuthStreamState extends State<AuthStream> {
  Widget screenHodler = MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: Container(),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (context, snapshot) {
          print(snapshot);
          if (snapshot.connectionState == ConnectionState.active) {
            final isLoggedIn = snapshot.hasData;
            print("isLoggedIn : $isLoggedIn");
            if (isLoggedIn) {
              print("${snapshot.data.email} has logged in..!");
              screenHodler = ShowCaseWidget(
                builder: Builder(builder: (context) => MainRoute(email: "고정")),
              );
            } else {
              screenHodler = WelcomeScreen();
            }
          }
          return screenHodler;
        });
  }
}
