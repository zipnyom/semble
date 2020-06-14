import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schuul/data/pageHolder.dart';
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
    return StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final isLoggedIn = snapshot.hasData;
            print("isLoggedIn : $isLoggedIn");
            if (isLoggedIn) {
              print("${snapshot.data.email} has logged in..");
              return MultiProvider(providers : [ChangeNotifierProvider(builder: (_) => PageProvider(), create: (BuildContext context) {  },)],child: MainRoute(email: snapshot.data.email));
            } else {
              return Scaffold(body: Body());
            }
          } else {
            return _buildWatingScreen();
          }
        });
  }
}

Widget _buildWatingScreen() {
  return Scaffold(
    body: Container(
      child: CircularProgressIndicator(),
      alignment: Alignment.center,
    ),
  );
}
