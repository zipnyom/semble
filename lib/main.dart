import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:schuul/experimental/quick_start.dart';
import 'package:schuul/screens/welcome/welcome_screen.dart';

import 'experimental/zefyrTest.dart';

// void main() => initializeDateFormatting().then((_) => runApp(MyApp()));
void main() =>  runApp(MyApp());
// void main() =>  runApp(ZefyrApp());

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
      home: WelcomeScreen(),
    );
  }
}
