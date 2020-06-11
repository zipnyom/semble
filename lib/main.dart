import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:schuul/screens/welcome/welcome_screen.dart';

void main() => initializeDateFormatting().then((_) => runApp(MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}

// class Splash extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//         stream: FirebaseAuth.instance.onAuthStateChanged,
//         builder: (context, snapshot) {
// //          print("snapshot.data => ${snapshot.data}");
//           if (snapshot.data == null) {
//             return MultiProvider(providers: [
//               ChangeNotifierProvider<JoinOrLogin>.value(
//                 value: JoinOrLogin(),
//               ),
//             ], child: AuthPage());
//           } else {
//             return MainRoute(email: snapshot.data.email);
//           }
//         });
//   }
// }
