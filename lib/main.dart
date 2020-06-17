import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:schuul/screens/main/main_route.dart';
import 'package:schuul/screens/welcome/welcome_screen.dart';
import 'package:showcaseview/showcase_widget.dart';
import 'data/page_provider.dart';
import 'experimental/showcase/show_case_test.dart';

// void main() => initializeDateFormatting().then((_) => runApp(MyApp()));
void main() => runApp(MyApp());
// void main() =>  runApp(ZefyrApp());
// void main() =>  runApp(ShowCaseApp());

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
        home: StreamBuilder(
            stream: FirebaseAuth.instance.onAuthStateChanged,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                final isLoggedIn = snapshot.hasData;
                print("isLoggedIn : $isLoggedIn");
                if (isLoggedIn) {
                  print("${snapshot.data.email} has logged in..");
                  return ShowCaseWidget(
                    builder: Builder(
                        builder: (context) =>
                            MainRoute(email: snapshot.data.email)),
                  );
                } else {
                  return WelcomeScreen();
                }
              } else {
                return _buildWatingScreen();
              }
            })
        //     ShowCaseWidget(
        //   builder: Builder(builder: (context) => MailPage()),
        // ),
        );
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
