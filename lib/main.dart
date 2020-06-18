import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:schuul/screens/login/login_screen.dart';
import 'package:schuul/screens/main/main_route.dart';
import 'package:schuul/screens/welcome/welcome_screen.dart';
import 'package:showcaseview/showcase_widget.dart';

// void main() => initializeDateFormatting().then((_) => runApp(MyApp()));
void main() => runApp(MyApp());
// void main() =>  runApp(ZefyrApp());
// void main() =>  runApp(ShowCaseApp());

Future<FirebaseUser> getCurrentUser() async {
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  return user;
}

class MyApp extends StatelessWidget {
  Widget screenHodler = MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: Container(),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', 'US'),
          const Locale('ko', 'KO'),
        ],
        home: StreamBuilder(
            stream: FirebaseAuth.instance.onAuthStateChanged,
            builder: (context, snapshot) {
              try {
                if (snapshot.connectionState == ConnectionState.active) {
                  final isLoggedIn = snapshot.hasData;
                  print("isLoggedIn : $isLoggedIn");
                  if (isLoggedIn) {
                    print("${snapshot.data.email} has logged in..!");
                    screenHodler = ShowCaseWidget(
                      builder:
                          Builder(builder: (context) => MainRoute(email: "고정")),
                    );
                  } else {
                    screenHodler = WelcomeScreen();
                  }
                }
                return screenHodler;
              } catch (e) {
                print(e);
              }
            }));
  }
}

Widget _buildWatingScreen() {
  return Scaffold(
    body: Container(
        // child: CircularProgressIndicator(),
        // alignment: Alignment.center,
        ),
  );
}
