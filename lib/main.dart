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

