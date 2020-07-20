import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schuul/src/data/provider/user_provider.dart';
import 'package:schuul/src/obj/user_detail.dart';
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
  Widget screenHodler2 = MaterialApp(
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
              FirebaseUser user = snapshot.data;
              print("${user.displayName} (${user.email}) has logged in..!");
              String path = "user/${user.uid}";
              print(path);
              screenHodler = StreamBuilder(
                  stream: Firestore.instance
                      .document("user/${user.uid}")
                      .snapshots(),
                  builder: (context, snapshot2) {
                    if (snapshot2.connectionState == ConnectionState.active &&
                        snapshot2.hasData) {
                      UserDetail userDetail =
                          UserDetail.fromJSON(snapshot2.data.data);
                      screenHodler2 = MultiProvider(
                        providers: [
                          ChangeNotifierProvider.value(
                              value: UserProvider()
                                ..user = user
                                ..userDetail = userDetail)
                        ],
                        child: ShowCaseWidget(
                          builder: Builder(
                              builder: (context) => MainRoute(email: "고정")),
                        ),
                      );
                    }
                    return screenHodler2;
                  });
            } else {
              screenHodler = WelcomeScreen();
            }
          }
          return screenHodler;
        });
  }
}
