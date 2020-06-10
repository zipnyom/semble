import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:schuul/screens/main/main_route.dart';
import 'package:schuul/screens/welcome/components/body.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (context, snapshot) {
//          print("snapshot.data => ${snapshot.data}");
          if (snapshot.data == null) {
            return Scaffold(
              body: Body(),
            );
          } else {
            return MainRoute(email: snapshot.data.email);
          }
        });
  }
}
