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
        home: FutureBuilder<FirebaseUser>(
            future: getCurrentUser(),
            builder:
                (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
              if (snapshot.hasData == false) return _buildWatingScreen();
              
              
              return ShowCaseWidget(
                builder: Builder(builder: (context) => MainRoute(email: "고정")),
              );
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
